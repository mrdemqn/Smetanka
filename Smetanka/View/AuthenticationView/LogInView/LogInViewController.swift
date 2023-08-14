//
//  RegistrationViewController.swift
//  Smetanka
//
//  Created by Димон on 7.08.23.
//

import UIKit

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
    }
}

extension LogInViewController {
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: localized(of: .authenticationTitle), style: .done, target: self, action: nil)
    }
}
