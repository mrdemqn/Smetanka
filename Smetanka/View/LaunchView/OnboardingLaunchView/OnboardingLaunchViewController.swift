//
//  LaunchViewController.swift
//  Onboarding
//
//  Created by Димон on 31.07.23.
//

import UIKit

final class OnboardingLaunchViewController: UIViewController {
    
    @IBOutlet private weak var overlayView: UIView!
    @IBOutlet weak var backgroundViewPlaceholder: UIView!
    
    private let animations: AnimationsProtocol = Animations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) { [weak self] in
            self?.setViewController(Navigation.onboarding,
                                    Navigation.containerPage)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            self?.animations.bezierHoleIntoView(self?.overlayView)
            self?.animations.bezierHoleIntoView(self?.backgroundViewPlaceholder)
        }
    }
}
