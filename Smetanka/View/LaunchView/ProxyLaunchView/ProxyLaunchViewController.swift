//
//  ProxyLaunchScreen.swift
//  Onboarding
//
//  Created by Димон on 1.08.23.
//

import UIKit

final class ProxyLaunchViewController: UIViewController {
    
    private var userDefaultsService: UserDefaultsServiceProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDefaultsService = UserDefaultsService()
        
        let onboardingShowed = userDefaultsService.getBool(UserDefaultKeys.onboardingShowed)

        let identifier = onboardingShowed ? Navigation.generalLaunch : Navigation.onboardingLaunch
        
        setViewController(identifier)
    }
}
