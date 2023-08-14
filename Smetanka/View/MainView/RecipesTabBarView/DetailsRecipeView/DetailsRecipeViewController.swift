//
//  DetailsRecipeViewController.swift
//  Smetanka
//
//  Created by Димон on 10.08.23.
//

import UIKit

class DetailsRecipeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Название рецепта"
        navigationItem.largeTitleDisplayMode = .never
    }
}
