//
//  ContainerPageViewController.swift
//  Smetanka
//
//  Created by Димон on 3.08.23.
//

import UIKit

final class ContainerPageViewController: UIViewController {
    
    private var onboardingPageViewController: OnboardingPageViewController?
    
    private var viewModel: OnboardingViewModelProtocol!
    
    @IBOutlet private weak var skipButton: UIButton!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var registrationButton: UIButton!
    
    @IBOutlet private weak var backButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var nextButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet private weak var registrationButtonLeadingConstraints: NSLayoutConstraint!
    @IBOutlet private weak var registrationButtonTrailingConstraint: NSLayoutConstraint!
    
    private var isLastPage = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OnboardingViewModel()
        
        textLocalization()
        getOnboardingViewController()
        
        initialPage()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction private func skipOnboardingAction() {
        onboardingPageViewController?.skipOnboarding(skipCompletion)
    }
    
    @IBAction private func nextPageAction() {
        if isLastPage {
            onboardingPageViewController?.pushLogInView()
        } else {
            onboardingPageViewController?.scrollToNextPage { index, isLastIndex in
                DispatchQueue.main.async { [weak self] in
                    self?.isLastPage = isLastIndex
                    
                    self?.constraintBottomButtons(index)
                    self?.changeNextButton()
                    self?.constraintRegistrationButton()
                    self?.hideSkipButton()
                    
                    self?.animate()
                }
            }
        }
    }
    
    @IBAction private func backAction() {
        onboardingPageViewController?.scrollToPreviousPage { index, isLastIndex in
            DispatchQueue.main.async { [weak self] in
                self?.isLastPage = isLastIndex
                
                self?.constraintBottomButtons(index)
                self?.changeNextButton()
                self?.constraintRegistrationButton()
                self?.hideSkipButton()
                
                self?.animate()
            }
        }
    }
    
    @IBAction private func registrationAction() {
        onboardingPageViewController?.pushRegistrationView()
    }
}

extension ContainerPageViewController {
    
    private func getOnboardingViewController() {
        guard let onboardingPageViewController = children.first(where: { controller in
            return controller is OnboardingPageViewController
        }) as? OnboardingPageViewController else { return }
        
        self.onboardingPageViewController = onboardingPageViewController
    }
    
    private func textLocalization() {
        skipButton.setTitle(localized(of: .skip), for: .normal)
        nextButton.setTitle(localized(of: .next), for: .normal)
        registrationButton.setTitle(localized(of: .registration), for: .normal)
    }
    
    private func changeNextButton() {
        if isLastPage {
            nextButton.setTitle(localized(of: .login), for: .normal)
        } else {
            nextButton.setTitle(localized(of: .next), for: .normal)
        }
    }
    
    private func hideSkipButton() {
        skipButton.isHidden = isLastPage
    }
    
    private func skipCompletion() {
        isLastPage = true
        
        DispatchQueue.main.async { [weak self] in
            self?.changeNextButton()
            self?.hideSkipButton()
            self?.constraintBottomButtons()
            self?.constraintRegistrationButton()
            
            self?.animate()
        }
    }
    
    private func constraintBottomButtons(_ index: Int = -1) {
        if index == 0 || isLastPage {
            backButtonLeadingConstraint.constant = -55
            nextButtonLeadingConstraint.constant = 25
        } else {
            backButtonLeadingConstraint.constant = 25
            nextButtonLeadingConstraint.constant = 15
        }
    }
    
    private func constraintRegistrationButton() {
        if isLastPage {
            registrationButtonLeadingConstraints.constant = 25
        } else {
            registrationButtonLeadingConstraints.constant = CGFloat(view.frame.size.width)
        }
    }
    
    func animate() {
        UIView.animate(withDuration: 0.4,
                       delay: 0,
                       options: .curveEaseOut) { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }
    
    private func initialPage() {
        isLastPage = viewModel.isOnboardingShowed
        let index = isLastPage ? -1 : 0
        
        DispatchQueue.main.async { [weak self] in
            self?.hideSkipButton()
            self?.changeNextButton()
            self?.constraintBottomButtons(index)
            self?.constraintRegistrationButton()
            
            self?.view.layoutIfNeeded()
        }
    }
}
