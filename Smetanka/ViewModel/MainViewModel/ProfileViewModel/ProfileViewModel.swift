//
//  ProfileViewModel.swift
//  Smetanka
//
//  Created by Димон on 2.09.23.
//

protocol ProfileViewModelProtocol {
    
    func logOut()
}

final class ProfileViewModel: ProfileViewModelProtocol {
    
    private var authService: AuthenticationServiceProtocol!
    
    init() {
        authService = AuthenticationService()
    }
    
    func logOut() {
        do {
            try authService.logOut()
        } catch {
            print(error)
        }
    }
}
