//
//  ProxyLaunchScreen.swift
//  Onboarding
//
//  Created by Димон on 1.08.23.
//

import UIKit

final class ProxyLaunchViewController: UIViewController {
    
    private var viewModel: ProxyLaunchViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ProxyLaunchViewModel()
        
        chooseAppDestination()
    }
}

extension ProxyLaunchViewController {
    
    private func chooseAppDestination() {
        let identifier = viewModel.isAuthenticate ? Navigation.mainLaunch : Navigation.onboardingLaunch
        
        if viewModel.isAuthenticate {
            
            if viewModel.isEmailVerified {
                setViewController(identifier)
            } else {
                let controller = ConfirmEmailViewController()
                setViewControllers(of: controller, animated: true)
            }
        } else {
            setViewController(identifier)
        }
    }
}
