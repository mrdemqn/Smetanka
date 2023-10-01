//
//  GeneralLaunchViewController.swift
//  Onboarding
//
//  Created by Димон on 1.08.23.
//

import UIKit
import Hero

final class MainLaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        setViewController(Navigation.mainTabBar, animated: true)
    }
}
