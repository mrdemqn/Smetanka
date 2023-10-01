//
//  AuthorizationViewModel.swift
//  Smetanka
//
//  Created by Димон on 8.08.23.
//

import FirebaseAuth
import RxSwift

protocol RegistrationViewModelProtocol {
    
    var isLoading: BehaviorSubject<Bool> { get }
    
    var successSubject: PublishSubject<User> { get }
    
    var failureSubject: PublishSubject<AuthErrorCode> { get }
    
    func createUser(_ email: String,
                    _ password: String)
}

final class RegistrationViewModel: RegistrationViewModelProtocol {
    
    private var authService: AuthenticationServiceProtocol!
    
    var isLoading: BehaviorSubject<Bool> = BehaviorSubject(value: false)

    var successSubject: PublishSubject<User> = PublishSubject()
    
    var failureSubject: PublishSubject<AuthErrorCode> = PublishSubject()
    
    init() {
        authService = AuthenticationService()
    }
    
    func createUser(_ email: String,
                    _ password: String) {
        isLoading.onNext(true)
        authService.createUser(email, password) { [weak self] result in
            self?.isLoading.onNext(false)
            switch result {
                case .success(let user):
                    self?.successSubject.onNext(user)
                case .failure(let authErrorCode, _):
                    self?.failureSubject.onNext(authErrorCode)
            }
        }
    }
}
