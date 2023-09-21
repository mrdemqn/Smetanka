//
//  OnboardingViewController.swift
//  Smetanka
//
//  Created by Димон on 2.08.23.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController {
    
    private var viewModel: OnboardingViewModelProtocol!
    
    var pageIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = OnboardingViewModel()
        
        initialPage()
    }
    
    private lazy var controllers: [UIViewController] = {
        return [
            getViewController(FirstPageViewController.self,
                              Navigation.firstPage),
            getViewController(SecondPageViewController.self,
                              Navigation.secondPage),
            getViewController(SecondPageViewController.self,
                              Navigation.secondPage),
            getViewController(SecondPageViewController.self,
                              Navigation.secondPage),
            getViewController(ThirdPageViewController.self,
                              Navigation.thirdPage)
        ]
    }()
}

extension OnboardingPageViewController {
    
    func scrollToNextPage(_ completion: @escaping (Int, Bool) -> Void) {
        
        let index = calculateNextIndex()
        
        setViewControllers([controllers[index]],
                           direction: .forward,
                           animated: true) { [weak self] arg in
            guard self != nil else { return }
            
            self!.pageIndex = index
            let isLastIndex = (self!.controllers.count - 1) == index
            completion(self!.pageIndex, isLastIndex)
        }
    }
    
    func scrollToPreviousPage(_ completion: @escaping (Int, Bool) -> Void) {
        
        let index = calculatePreviousIndex()
        
        setViewControllers([controllers[index]],
                           direction: .reverse,
                           animated: true) { [weak self] arg in
            guard self != nil else { return }
            
            self!.pageIndex = index
            let isLastIndex = (self!.controllers.count - 1) == index
            completion(self!.pageIndex, isLastIndex)
        }
    }
    
    func skipOnboarding(_ completion: @escaping () -> Void) {
        let lastIndex = controllers.count - 1
        
        viewModel.setOnboardingShowed()
        setViewControllers([controllers[lastIndex]],
                           direction: .forward,
                           animated: true) { [weak self] arg in
            guard self != nil else { return }
            
            self!.pageIndex = lastIndex
            completion()
        }
    }
    
    func pushLogInView() {
        viewModel.setOnboardingShowed()
        let controller = LogInViewController()
        push(of: controller)
    }
    
    func pushRegistrationView() {
        viewModel.setOnboardingShowed()
        push(to: Navigation.registration)
    }
    
    private func calculateNextIndex() -> Int {
        let lastIndex = controllers.count - 1
        let nextIndex = pageIndex + 1
        
        if pageIndex < lastIndex {
            return nextIndex
        }
        
        return pageIndex
    }
    
    private func calculatePreviousIndex() -> Int {
        let firstIndex = 0
        let previousIndex = pageIndex - 1
        
        if previousIndex < pageIndex && previousIndex >= firstIndex {
            return previousIndex
        }
        
        return pageIndex
    }
    
    private func initialPage() {
        let controller = viewModel.isOnboardingShowed ? controllers.last : controllers.first
        
        guard let controller = controller else { return }
        
        setViewControllers([controller],
                           direction: .forward,
                           animated: true)
    }
}
