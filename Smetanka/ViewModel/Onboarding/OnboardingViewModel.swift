//
//  OnboardingViewModel.swift
//  Smetanka
//
//  Created by Димон on 7.08.23.
//

protocol OnboardingViewModelProtocol {
    
    var isOnboardingShowed: Bool { get }
    
    func setOnboardingShowed()
}

final class OnboardingViewModel: OnboardingViewModelProtocol {
    
    private var userDefaultsService: UserDefaultsServiceProtocol!
    
    var isOnboardingShowed: Bool
    
    init() {
        userDefaultsService = UserDefaultsService()
        isOnboardingShowed = userDefaultsService.getBool(UserDefaultKeys.onboardingShowed)
    }
    
    func setOnboardingShowed() {
        if !isOnboardingShowed {
            userDefaultsService.setBool(true, UserDefaultKeys.onboardingShowed)
        }
    }
}
