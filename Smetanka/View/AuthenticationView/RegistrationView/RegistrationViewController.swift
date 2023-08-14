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
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet private weak var emailTextField: RegistrationTextField!
    @IBOutlet private weak var passwordTextField: RegistrationTextField!
    @IBOutlet private weak var confirmPasswordTextField: RegistrationTextField!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RegistrationViewModel()
        
        setupNavigationBar()
        setupTextFields()
        
        setupKeyboardDismiss()
        setupKeyboardObservable()
        
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillShowNotification,
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: UIResponder.keyboardWillHideNotification,
                                                  object: nil)
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
    
    private func bindViewModel() {
        /// MARK: Subscribe loading view
        viewModel.isLoading.subscribe { [weak self] isLoading in
            DispatchQueue.main.async {
                self?.loadingView.isHidden = !isLoading
            }
        }.disposed(by: disposeBag)
        
        /// MARK: Subscribe success response
        viewModel.successSubject.subscribe{ [weak self] user in
            self?.push(to: Navigation.mainTabBar)
        }.disposed(by: disposeBag)
        
        /// MARK: Subscribe failure response
        viewModel.failureSubject.subscribe { [weak self] authErrorCode in
            DispatchQueue.main.async {
                self?.showErrorAlert()
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
        scrollView.isScrollEnabled = true
        guard let userInfo = notification.userInfo else { return }
        let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardEndFrame.height - view.layoutMargins.bottom
        scrollView.contentInset.bottom = keyboardEndFrame.height - view.layoutMargins.bottom
        
        var frame = CGRect.zero
        
        if emailTextField.isFirstResponder {
            frame = CGRect(x: emailTextField.frame.origin.x,
                           y: emailTextField.frame.origin.y + 50,
                           width: emailTextField.frame.size.width,
                           height: emailTextField.frame.size.height)
        }
        
        if passwordTextField.isFirstResponder {
            frame = CGRect(x: passwordTextField.frame.origin.x,
                           y: passwordTextField.frame.origin.y + 50,
                           width: passwordTextField.frame.size.width,
                           height: passwordTextField.frame.size.height)
        }
        
        if confirmPasswordTextField.isFirstResponder {
            frame = CGRect(x: confirmPasswordTextField.frame.origin.x,
                           y: confirmPasswordTextField.frame.origin.y + 50,
                           width: confirmPasswordTextField.frame.size.width,
                           height: confirmPasswordTextField.frame.size.height)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.scrollView.scrollRectToVisible(frame, animated: true)
        }
    }
    
    @objc private func keyboardWillHide() {
        scrollView.isScrollEnabled = false
        let offset = CGPoint(x: 0, y: scrollView.contentInset.top)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            print("Scroll")
            self?.scrollView.setContentOffset(offset, animated: true)
        }
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


final class RegistrationTextField: UITextField {
    
    private let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupTextField()
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        bounds.inset(by: padding)
    }
    
    func setupPlaceholder(_ placeholder: String) {
        self.placeholder = placeholder
    }
    
    private func setupTextField() {
        textColor = UIColor(named: "FieldText")
        
        layer.cornerRadius = 10
        layer.backgroundColor = UIColor.red.cgColor
        
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.3
        layer.shadowOffset = CGSize(width: 10, height: 10)
        
        font = UIFont(name: Font.helveticaNeue, size: 14)
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
}
