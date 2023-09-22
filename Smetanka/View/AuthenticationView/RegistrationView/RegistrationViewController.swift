//
//  LogInViewController.swift
//  Smetanka
//
//  Created by Димон on 7.08.23.
//

import UIKit
import RxSwift

final class RegistrationViewController: UIViewController {
    
    private var viewModel: RegistrationViewModelProtocol!
    
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var contentView: UIView!
    
    @IBOutlet private weak var emailTextField: AuthField!
    @IBOutlet private weak var passwordTextField: AuthField!
    @IBOutlet private weak var confirmPasswordTextField: AuthField!
    
    private let disposeBag = DisposeBag()
    
    private var confirmPasswordTextFieldY: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RegistrationViewModel()
        
        setupNavigationBar()
        setupTextFields()
        
        setupKeyboardDismiss()
        setupKeyboardObservable()
        
        bindViewModel()
        
        confirmPasswordTextFieldY = confirmPasswordTextField.frame.origin.y
    }
    
    deinit {
        removeKeyboardObservers()
    }
    
    @IBAction func registerAction() {
        guard let email = emailTextField.text, email.isNotEmpty,
              let password = passwordTextField.text, password.isNotEmpty,
              let confirmPassword = confirmPasswordTextField.text, confirmPassword.isNotEmpty else { return }
        
        viewModel.createUser(email,
                             password)
    }
}

extension RegistrationViewController {
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: localized(of: .authenticationTitle), style: .done, target: self, action: nil)
    }
    
    private func setupTextFields() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        emailTextField.setupPlaceholder(localized(of: .emailPlaceholder))
        passwordTextField.setupPlaceholder(localized(of: .passwordPlaceholder))
        confirmPasswordTextField.setupPlaceholder(localized(of: .confirmPasswordPlaceholder))
    }
    
    private func setupKeyboardDismiss() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(recognizer)
    }
    
    private func setupKeyboardObservable() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
    }
    
    private func bindViewModel() {
        /// MARK: Subscribe loading view
        viewModel.isLoading.subscribe { isLoading in
            DispatchQueue.main.async { [unowned self] in
                showLoader(localized(of: .pleaseWait))
            }
        }.disposed(by: disposeBag)
        
        /// MARK: Subscribe success response
        viewModel.successSubject.subscribe { [unowned self] event in
            guard let user = event.element else { return }
            if user.isEmailVerified {
                setViewController(Navigation.mainTabBar)
            } else {
                let controller = ConfirmEmailViewController()
                setViewControllers(of: controller, animated: true)
            }
        }.disposed(by: disposeBag)
        
        /// MARK: Subscribe failure response
        viewModel.failureSubject.subscribe { error in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [unowned self] in
                let message = ErrorMessages.describeFBCode(error.code)
                showErrorAlert(message?.title, message?.message)
            }
        }.disposed(by: disposeBag)
    }
}

extension RegistrationViewController {
    
    @objc private func dismissKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        confirmPasswordTextField.resignFirstResponder()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let frame = userInfo.cgRectValue
        
        if frame.origin.y >= confirmPasswordTextFieldY {
            let difference = frame.origin.y - confirmPasswordTextFieldY
            scrollView.contentOffset = CGPoint(x: 0, y: difference)
        }
    }
    
    @objc private func keyboardWillHide() {
        let offset = CGPoint(x: 0, y: -60)
        scrollView.contentOffset = offset
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case emailTextField:
                passwordTextField.becomeFirstResponder()
            case passwordTextField:
                confirmPasswordTextField.becomeFirstResponder()
            default:
                dismissKeyboard()
        }
        
        return true
    }
}
