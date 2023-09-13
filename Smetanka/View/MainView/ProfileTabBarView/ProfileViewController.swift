//
//  ProfileViewController.swift
//  Smetanka
//
//  Created by Димон on 2.09.23.
//

import UIKit

class ProfileViewController: UIViewController {

    private var viewModel: ProfileViewModelProtocol!
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let contentHeaderLabel = UILabel()
    private var changeThemeButton = AppButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ProfileViewModel()
        setupNavigationBar()
        configureLayout()
        prepareViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareChangeButtonLayer()
    }
}

/// MARK - Конфигурация ScrollView, ContentView и контента внутри
private extension ProfileViewController {
    
    func configureLayout() {
        configureSuperView()
        configureScrollView()
        configureContentView()
        configureChangeThemeButton()
    }
    
    func prepareViews() {
        prepareScrollView()
        prepareChangeThemeButton()
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
    
    func configureChangeThemeButton() {
        var configuration = UIButton.Configuration.plain()
        
        configuration.image = .init(systemName: "chevron.forward")
        configuration.imageColorTransformer = .init({ _ in .gray })
        configuration.imagePlacement = .trailing
        
        let button = AppButton(configuration: configuration)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitleColor(.generalText, for: .normal)
        button.titleLabel?.font = .helveticaNeueFont(18)
        button.contentHorizontalAlignment = .fill
        button.setTitle(localized(of: .themeButton), for: .normal)
        
        changeThemeButton = button
        
        prepareNavigateChangeThemeAction()
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
    
    func prepareChangeThemeButton() {
        contentView.addSubview(changeThemeButton)
        
        NSLayoutConstraint.activate([
            changeThemeButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 50),
            changeThemeButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            changeThemeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            changeThemeButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    func prepareChangeButtonLayer() {
        changeThemeButton.addVerticalBorder(borderWidth: 1)
    }
    
    func setupNavigationBar() {
        navigationItem.title = localized(of: .profileHeader)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

private extension ProfileViewController {
    
    func prepareNavigateChangeThemeAction() {
        changeThemeButton.addTarget(self,
                                    action: #selector(navigateChangeThemeAction),
                                    for: .touchUpInside)
    }
    
    @objc func navigateChangeThemeAction() {
        let controller = ChangeThemeViewController()
        guard let sheet = controller.sheetPresentationController else { return }
        sheet.detents = [.medium()]
        sheet.preferredCornerRadius = 30
        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        
        present(to: controller)
    }
}
