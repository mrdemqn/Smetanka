//
//  CreateRecipeViewController.swift
//  Smetanka
//
//  Created by Димон on 21.09.23.
//

import UIKit
import Hero

final class CreateRecipeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        isHeroEnabled = true
        
        view.backgroundColor = .background
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = localized(of: .recipe)
        navigationItem.largeTitleDisplayMode = .never
    }
}
