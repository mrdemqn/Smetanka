//
//  AuthenticationService.swift
//  Smetanka
//
//  Created by Димон on 8.08.23.
//

import FirebaseAuth

protocol AuthenticationServiceProtocol {
    
    var isAuthenticate: Bool { get }
    
    var isEmailVerified: Bool { get }
    
    func createUser(_ email: String,
                    _ password: String,
                    _ completion: @escaping (AppResult<User, AuthErrorCode>) -> Void)
    
    func signInWithEmail(_ email: String,
                    _ password: String,
                    _ completion: @escaping (AppResult<User, AuthErrorCode>) -> Void)
    
    func logOut() throws
}

final class AuthenticationService: AuthenticationServiceProtocol {
    
    private var firebaseService: FirebaseServiceProtocol!
    
    private let authQueue = DispatchQueue(label: MultiThreading.authQueueLabel)
    
    var isAuthenticate: Bool {
        return firebaseService.isAuthenticate
    }
    
    var isEmailVerified: Bool {
        return firebaseService.isEmailVerified
    }
    
    init() {
        firebaseService = FirebaseService()
    }
    
    func createUser(_ email: String,
                    _ password: String,
                    _ completion: @escaping (AppResult<User, AuthErrorCode>) -> Void) {
        authQueue.async { [weak self] in
            self?.firebaseService.createUser(email, password, completion)
        }
    }
    
    func signInWithEmail(_ email: String,
                         _ password: String,
                         _ completion: @escaping (AppResult<User, AuthErrorCode>) -> Void) {
        authQueue.async { [weak self] in
            self?.firebaseService.signIn(email, password, completion)
        }
    }
    
    func logOut() throws {
        do {
            try firebaseService.signOut()
        } catch {
            print(error)
        }
    }
}
