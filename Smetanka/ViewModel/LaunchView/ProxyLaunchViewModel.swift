//
//  ProxyLaunchViewModel.swift
//  Smetanka
//
//  Created by Димон on 7.08.23.
//


protocol ProxyLaunchViewModelProtocol {
    
    var isAuthenticate: Bool { get }
}

final class ProxyLaunchViewModel: ProxyLaunchViewModelProtocol {
    
    private var authService: AuthenticationServiceProtocol!
    
    var isAuthenticate: Bool {
        return authService.isAuthenticate
    }
    
    init() {
        authService = AuthenticationService()
    }
}
