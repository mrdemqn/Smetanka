//
//  ContainerPageViewController.swift
//  Smetanka
//
//  Created by Димон on 3.08.23.
//

import UIKit

final class ContainerPageViewController: UIViewController {
    
    private var onboardingViewController: OnboardingViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingViewController = getViewController(OnboardingViewController.self,
                                                     Navigation.onboarding)
        
//        addChild(onboardingViewController)
//        view.addSubview(onboardingViewController.view)
//        onboardingViewController.didMove(toParent: self)
    }
    
    @IBAction func skipOnboardingAction() {
        onboardingViewController.skipOnboarding()
    }
    
    @IBAction func nextPageAction() {
        onboardingViewController.scrollToNextPage()
    }
}
