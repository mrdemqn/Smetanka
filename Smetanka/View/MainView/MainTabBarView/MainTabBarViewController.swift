//
//  MainViewController.swift
//  Smetanka
//
//  Created by Димон on 9.08.23.
//

import UIKit

final class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let profileViewController = ProfileViewController()
        
        profileViewController.tabBarItem.image = .init(systemName: "person.crop.circle")
        
        viewControllers?.remove(at: 3)
        viewControllers?.append(profileViewController)
    }
}
