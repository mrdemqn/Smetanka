//
//  ThirdPageViewController.swift
//  Smetanka
//
//  Created by Димон on 7.08.23.
//

import UIKit

class ThirdPageViewController: UIViewController {

    @IBOutlet private weak var appNameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textLocalization()
    }
}

extension ThirdPageViewController {
    
    private func textLocalization() {
        appNameLabel.text = localized(of: .appName)
    }
}
