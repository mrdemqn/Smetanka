//
//  FirstPageViewController.swift
//  Smetanka
//
//  Created by Димон on 2.08.23.
//

import UIKit

final class FirstPageViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = localized(of: .firstOnboardingTitle)
    }
}
