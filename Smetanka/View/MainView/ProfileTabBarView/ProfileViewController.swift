//
//  ProfileViewController.swift
//  Smetanka
//
//  Created by Димон on 2.09.23.
//

import UIKit
import FirebaseAuth

final class ProfileViewController: UIViewController {

    private var viewModel: ProfileViewModelProtocol!
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let contentHeaderLabel = UILabel()
    private var changeThemeButton = AppButton()
    
    private let logOutButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ProfileViewModel()
        setupNavigationBar()
        configureLayout()
        prepareViews()
        
        Auth.auth().addStateDidChangeListener { auth, user in
            if user != nil {
                print("Not Nil: \(user?.isEmailVerified)")
            } else {
                self.tabBarController?.tabBar.isHidden = true
                self.setViewController(Navigation.onboardingLaunch)
            }
        }
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
        configureLogOutButton()
    }
    
    func prepareViews() {
        prepareScrollView()
        prepareChangeThemeButton()
        prepareLogOutButton()
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
    
    func configureLogOutButton() {
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.setTitle(localized(of: .logOut), for: .normal)
        logOutButton.setTitleColor(.black, for: .normal)
        logOutButton.backgroundColor = .main
        logOutButton.layer.cornerRadius = 15
        logOutButton.frame = CGRect(x: 0, y: 0, width: 0, height: 55)
        
        prepareLogOutAction()
    }
    
    func prepareScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
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
        ])
    }
    
    func prepareChangeButtonLayer() {
        changeThemeButton.addVerticalBorder(borderWidth: 1)
    }
    
    func prepareLogOutButton() {
        contentView.addSubview(logOutButton)
        
        NSLayoutConstraint.activate([
            logOutButton.topAnchor.constraint(equalTo: changeThemeButton.bottomAnchor, constant: 30),
            logOutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            logOutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            logOutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            logOutButton.heightAnchor.constraint(equalToConstant: 55)
        ])
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
    
    func prepareLogOutAction() {
        logOutButton.addTarget(self, 
                               action: #selector(logOutUser),
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
    
    @objc func logOutUser() {
        print(#function)
        viewModel.logOut()
    }
}
