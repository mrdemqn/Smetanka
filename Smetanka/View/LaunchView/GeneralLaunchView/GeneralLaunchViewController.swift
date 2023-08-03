//
//  GeneralLaunchViewController.swift
//  Onboarding
//
//  Created by Димон on 1.08.23.
//

import UIKit

final class GeneralLaunchViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            
            let storyboard = UIStoryboard(name: "Main",
                                          bundle: nil)
            let viewController = storyboard.instantiateViewController(withIdentifier: "Main")
            self?.navigationController?.setViewControllers([viewController], animated: false)
        }
    }
}
