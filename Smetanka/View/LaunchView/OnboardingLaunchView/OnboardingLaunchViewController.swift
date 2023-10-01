//
//  LaunchViewController.swift
//  Onboarding
//
//  Created by Димон on 31.07.23.
//

import UIKit
import Hero

final class OnboardingLaunchViewController: UIViewController {
    
    private let animations = Animations.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewController(Navigation.onboarding,
                          Navigation.containerPage)
    }
}
