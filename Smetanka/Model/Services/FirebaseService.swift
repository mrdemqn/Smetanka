//
//  FirebaseService.swift
//  Smetanka
//
//  Created by Димон on 8.08.23.
//

import FirebaseAuth
import FirebaseDatabase

protocol FirebaseServiceProtocol {
    
    var isAuthenticate: Bool { get }
    
    var isEmailVerified: Bool { get }
    
    func createUser(_ email: String,
                    _ password: String,
                    _ completion: @escaping (AppResult<User, AuthErrorCode>) -> Void)
    
    func signIn(_ email: String,
                _ password: String,
                _ completion: @escaping (AppResult<User, AuthErrorCode>) -> Void)
    
    func signOut() throws
    
    func reloadUserData()
}

final class FirebaseService: FirebaseServiceProtocol {
    
    private let auth = Auth.auth()
    
    private var ref: DatabaseReference!
    
    init() {
        ref = Database.database().reference()
    }
    
    var isAuthenticate: Bool {
        return auth.currentUser != nil
    }
    
    var isEmailVerified: Bool {
        guard let user = auth.currentUser else { return false }
        return user.isEmailVerified
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
    
    func reloadUserData() {
        auth.currentUser?.reload()
    }
}
