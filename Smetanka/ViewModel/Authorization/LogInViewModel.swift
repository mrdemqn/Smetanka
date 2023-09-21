//
//  LogInViewModel.swift
//  Smetanka
//
//  Created by Димон on 8.08.23.
//

import FirebaseAuth
import RxSwift

protocol LogInViewModelProtocol {
    
    var loadingSubject: BehaviorSubject<Bool> { get }
    
    var successSubject: PublishSubject<User> { get }
    
    var failureSubject: PublishSubject<AuthErrorCode> { get }
    
    func signInWithEmail(_ email: String,
                    _ password: String)
}

final class LogInViewModel: LogInViewModelProtocol {
    
    private var authService: AuthenticationServiceProtocol!
    
    var loadingSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)

    var successSubject: PublishSubject<User> = PublishSubject()
    
    var failureSubject: PublishSubject<AuthErrorCode> = PublishSubject()
    
    init() {
        authService = AuthenticationService()
    }
    
    func signInWithEmail(_ email: String,
                         _ password: String) {
        loadingSubject.onNext(true)
        authService.signInWithEmail(email, password) { [weak self] result in
            self?.loadingSubject.onNext(false)
            switch result {
                case .success(let user):
                    self?.successSubject.onNext(user)
                case .failure(let custom, _):
                    self?.failureSubject.onNext(custom)
            }
        }
    }
}
