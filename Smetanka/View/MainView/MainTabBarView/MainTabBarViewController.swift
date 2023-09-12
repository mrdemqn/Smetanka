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
        
        let favouriteViewController = FavouriteViewController()
        let favouriteNavigation = UINavigationController(rootViewController: favouriteViewController)
        
        let myRecipesViewController = MyRecipesViewController()
        let myRecipesNavigation = UINavigationController(rootViewController: myRecipesViewController)
        let profileViewController = ProfileViewController()
        
        myRecipesViewController.tabBarItem.image = .init(systemName: "bookmark")
        myRecipesViewController.tabBarItem.selectedImage = .init(systemName: "bookmark.fill")
        
        favouriteViewController.tabBarItem.image = .init(systemName: "star")
        favouriteViewController.tabBarItem.selectedImage = .init(systemName: "star.fill")
        
        profileViewController.tabBarItem.image = .init(systemName: "person.crop.circle")
        
        viewControllers?.append(favouriteNavigation)
        viewControllers?.append(myRecipesNavigation)
        viewControllers?.append(profileViewController)
    }
}
