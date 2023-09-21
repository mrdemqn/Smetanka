//
//  FirebaseService.swift
//  Smetanka
//
//  Created by Димон on 8.08.23.
//

import FirebaseAuth

protocol FirebaseServiceProtocol {
    
    var isAuthenticate: Bool { get }
    
    func createUser(_ email: String,
                    _ password: String,
                    _ completion: @escaping (AppResult<User, AuthErrorCode>) -> Void)
    
    func signIn(_ email: String,
                _ password: String,
                _ completion: @escaping (AppResult<User, AuthErrorCode>) -> Void)
    
    func signOut() throws
}

final class FirebaseService: FirebaseServiceProtocol {
    
    private let auth = Auth.auth()
    
    var isAuthenticate: Bool {
        return auth.currentUser != nil
    }
    
    func createUser(_ email: String,
                    _ password: String,
                    _ completion: @escaping (AppResult<User, AuthErrorCode>) -> Void) {
        auth.createUser(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                guard let e = error as? AuthErrorCode else { return }
                completion(.failure(custom: e))
                return
            }
            
            guard let authResult = authResult else { return }
            
            authResult.user.sendEmailVerification { error in
                guard error == nil else { 
                    guard let e = error as? AuthErrorCode else { return }
                    completion(.failure(custom: e, error))
                    return
                }
                completion(.success(result: authResult.user))
            }
        }
    }
    
    func signIn(_ email: String,
                _ password: String,
                _ completion: @escaping (AppResult<User, AuthErrorCode>) -> Void) {
        auth.signIn(withEmail: email, password: password) { authResult, error in
            guard error == nil else {
                guard let e = error as? AuthErrorCode else { return }
                completion(.failure(custom: e))
                return
            }
            
            guard let authResult = authResult else { return }
            
            completion(.success(result: authResult.user))
        }
    }
    
    func signOut() throws {
        do {
            try auth.signOut()
        } catch let signOutError {
            print("Error signing out: %@", signOutError)
        }
    }
}
