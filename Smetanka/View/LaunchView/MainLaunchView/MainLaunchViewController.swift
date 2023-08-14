//
//  GeneralLaunchViewController.swift
//  Onboarding
//
//  Created by Димон on 1.08.23.
//

import UIKit

final class MainLaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.setViewController(Navigation.mainTabBar, animated: true)
        }
    }
}
