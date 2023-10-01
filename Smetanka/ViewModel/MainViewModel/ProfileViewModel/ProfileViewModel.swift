//
//  ProfileViewModel.swift
//  Smetanka
//
//  Created by Димон on 2.09.23.
//

import RxSwift

protocol ProfileViewModelProtocol {
    
    var failureSubject: PublishSubject<Void> { get }
    
    func logOut()
}

final class ProfileViewModel: ProfileViewModelProtocol {
    
    private var authService: AuthenticationServiceProtocol!
    
    var failureSubject: PublishSubject<Void> = PublishSubject<Void>()
    
    init() {
        authService = AuthenticationService()
    }
    
    func logOut() {
        do {
            try authService.logOut()
        } catch {
            failureSubject.on(.error(error))
        }
    }
}
