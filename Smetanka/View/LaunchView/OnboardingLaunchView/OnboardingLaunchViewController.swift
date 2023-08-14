//
//  LaunchViewController.swift
//  Onboarding
//
//  Created by Димон on 31.07.23.
//

import UIKit

final class OnboardingLaunchViewController: UIViewController {
    
    @IBOutlet private weak var overlayView: UIView!
    @IBOutlet private weak var nextButton: UIButton!
    @IBOutlet private weak var skipButton: UIButton!
    
    private let animations = Animations.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLocalization()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) { [weak self] in
            self?.setViewController(Navigation.onboarding,
                                    Navigation.containerPage)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.animations.bezierHoleIntoView(self?.overlayView)
        }
    }
}

extension OnboardingLaunchViewController {
    
    private func textLocalization() {
        skipButton.setTitle(localized(of: .skip), for: .normal)
        nextButton.setTitle(localized(of: .next), for: .normal)
    }
}
