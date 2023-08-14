//
//  LogInViewModel.swift
//  Smetanka
//
//  Created by Димон on 8.08.23.
//

import FirebaseAuth

protocol LogInViewModelProtocol {
    
    func createUser(_ email: String,
                    _ password: String,
                    _ completion: @escaping (AppResult<User, AuthErrorCode>) -> Void)
    
    func signInWithEmail(_ email: String,
                    _ password: String,
                    _ completion: @escaping (AppResult<User, AuthErrorCode>) -> Void)
}

final class LogInViewModel: LogInViewModelProtocol {
    
    private var authService: AuthenticationServiceProtocol!
    
    init() {
        authService = AuthenticationService()
    }
    
    func createUser(_ email: String,
                    _ password: String,
                    _ completion: @escaping (AppResult<User, AuthErrorCode>) -> Void) {
        authService.createUser(email, password) { result in
            switch result {
                case .success(let user):
                    print("User: \(user.uid)")
                case .failure(let custom, _):
                    print("Error: \(custom.errorCode)")
            }
        }
    }
    
    func signInWithEmail(_ email: String,
                         _ password: String,
                         _ completion: @escaping (AppResult<User, AuthErrorCode>) -> Void) {
        authService.signInWithEmail(email, password) { result in
            switch result {
                case .success(let user):
                    print("User: \(user.uid)")
                case .failure(let custom, _):
                    print("Error: \(custom.errorCode)")
            }
        }
    }
}
