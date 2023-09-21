//
//  ChangeThemeViewModel.swift
//  Smetanka
//
//  Created by Димон on 21.09.23.
//

protocol ChangeThemeViewModelProtocol {
    
    func saveTheme(_ themeKey: Int)
}

final class ChangeThemeViewModel: ChangeThemeViewModelProtocol {
    
    private var userDefaultsService: UserDefaultsServiceProtocol!
    
    init() {
        userDefaultsService = UserDefaultsService()
    }
    
    func saveTheme(_ themeKey: Int) {
        userDefaultsService.setInt(themeKey, UserDefaultKeys.theme)
    }
}
