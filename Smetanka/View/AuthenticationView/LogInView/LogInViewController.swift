//
//  RegistrationViewController.swift
//  Smetanka
//
//  Created by Димон on 7.08.23.
//

import UIKit
import RxSwift

final class LogInViewController: UIViewController {
    
    private var viewModel: LogInViewModelProtocol!
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let emailTextField = AuthField()
    private let passwordTextField = AuthField()
    
    private let headerLabel = UILabel()
    private let subHeaderLabel = UILabel()
    private let emailFieldTitleLabel = UILabel()
    private let passwordFieldTitleLabel = UILabel()
    
    private let loginButton = UIButton()
    
    private let disposeBag = DisposeBag()
    
    private var confirmPasswordTextFieldY: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = LogInViewModel()
        bindViewModel()
        
        setupNavigationBar()
        setupKeyboardDismiss()
        configureLayout()
        prepareLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        confirmPasswordTextFieldY = passwordTextField.frame.origin.y
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
        configureLabels()
        configureTextFileds()
        configureLoginButton()
    }
    
    func prepareLayout() {
        prepareScrollView()
        prepareLabels()
        prepareFields()
        prepareLoginButton()
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
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        emailFieldTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordFieldTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerLabel.text = localized(of: .loginHeader)
        subHeaderLabel.text = localized(of: .loginSubHeader)
        emailFieldTitleLabel.text = localized(of: .emailFieldTitle)
        passwordFieldTitleLabel.text = localized(of: .passwordFieldTitle)
        
        headerLabel.font = .helveticaNeueFont(24, weight: .heavy)
        subHeaderLabel.font = .helveticaNeueFont(14, weight: .medium)
        emailFieldTitleLabel.font = .helveticaNeueFont(14, weight: .bold)
        passwordFieldTitleLabel.font = .helveticaNeueFont(14, weight: .bold)
    }
    
    func configureTextFileds() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.setupPlaceholder(localized(of: .emailPlaceholder))
        passwordTextField.setupPlaceholder(localized(of: .passwordPlaceholder))
        
        emailTextField.textContentType = .emailAddress
        passwordTextField.isSecureTextEntry = true
    }
    
    func configureLoginButton() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle(localized(of: .login), for: .normal)
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.backgroundColor = .main
        loginButton.layer.cornerRadius = 15
        
        loginButton.addTarget(self, action: #selector(loginUser), for: .touchUpInside)
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
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func prepareLabels() {
        contentView.addSubview(headerLabel)
        contentView.addSubview(subHeaderLabel)
        contentView.addSubview(emailFieldTitleLabel)
        contentView.addSubview(passwordFieldTitleLabel)
        
        NSLayoutConstraint.activate([
            /// MARK - Header Label
            headerLabel.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 40),
            headerLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            headerLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            
            /// MARK - SubHeader Label
            subHeaderLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 15),
            subHeaderLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            subHeaderLabel.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor)
        ])
    }
    
    func prepareFields() {
        contentView.addSubview(emailFieldTitleLabel)
        contentView.addSubview(passwordFieldTitleLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        
        NSLayoutConstraint.activate([
            /// MARK - Email Field Title Label
            emailFieldTitleLabel.topAnchor.constraint(equalTo: subHeaderLabel.bottomAnchor, constant: 30),
            emailFieldTitleLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            emailFieldTitleLabel.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor),
            
            /// MARK - Email Text Field
            emailTextField.topAnchor.constraint(equalTo: emailFieldTitleLabel.bottomAnchor, constant: 10),
            emailTextField.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor),
            
            /// MARK - Password Field Title Label
            passwordFieldTitleLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 30),
            passwordFieldTitleLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            passwordFieldTitleLabel.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor),
            
            /// MARK - Password Text Field
            passwordTextField.topAnchor.constraint(equalTo: passwordFieldTitleLabel.bottomAnchor, constant: 10),
            passwordTextField.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor)
        ])
    }
    
    func prepareLoginButton() {
        contentView.addSubview(loginButton)
        
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(greaterThanOrEqualTo: passwordTextField.bottomAnchor, constant: 10),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            loginButton.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            loginButton.heightAnchor.constraint(equalToConstant: 55)
        ])
    }
}

private extension LogInViewController {
    
    @objc func loginUser() {
        guard let email = emailTextField.text, email.isNotEmpty,
              let password = passwordTextField.text, password.isNotEmpty else { return }
        dismissKeyboard()
        viewModel.signInWithEmail(email, password)
    }
    
    func bindViewModel() {
        var loader = UIAlertController()
        viewModel.loadingSubject.subscribe(onNext: { [unowned self] isLoading in
            if isLoading {
                loader = showLoader(localized(of: .pleaseWait))
            } else {
                stopLoader(loader: loader)
            }
        }).disposed(by: disposeBag)
        
        viewModel.successSubject.subscribe(onNext: { [unowned self] user in
            if user.isEmailVerified {
                self.setViewController(Navigation.mainTabBar, animated: true)
            } else {
                let controller = ConfirmEmailViewController()
                present(to: controller, style: .overFullScreen)
            }
        }).disposed(by: disposeBag)
        
        viewModel.failureSubject.subscribe(onNext: { [unowned self] error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let message = ErrorMessages.describeFBCode(error.code)
                self.showErrorAlert(message?.title, message?.message)
            }
        }).disposed(by: disposeBag)
    }
}

extension LogInViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case emailTextField:
                passwordTextField.becomeFirstResponder()
            default:
                dismissKeyboard()
        }
        
        return true
    }
    
    private func setupKeyboardDismiss() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(recognizer)
    }
    
    @objc private func dismissKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
}
