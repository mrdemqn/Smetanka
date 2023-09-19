//
//  RegistrationViewController.swift
//  Smetanka
//
//  Created by Димон on 7.08.23.
//

import UIKit

final class LogInViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let emailTextField = AuthField()
    private let passwordTextField = AuthField()
    
    private let headerLabel = UILabel()
    private let subHeaderLabel = UILabel()
    private let emailFieldTitleLabel = UILabel()
    private let passwordFieldTitleLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureLayout()
        prepareLayout()
    }
}

private extension LogInViewController {
    
    func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: localized(of: .authenticationTitle), style: .done, target: self, action: nil)
    }
    
    func configureLayout() {
        configureSuperView()
        configureScrollView()
        configureContentView()
    }
    
    func prepareLayout() {
        prepareScrollView()
    }
    
    func configureSuperView() {
        view.backgroundColor = .background
    }
    
    func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .background
    }
    
    func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .background
    }
    
    func configureLabels() {
        headerLabel.text = localized(of: .appName)
    }
    
    func prepareScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}
