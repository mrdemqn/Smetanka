//
//  UserDefaultsService.swift
//  Smetanka
//
//  Created by Димон on 2.08.23.
//

import Foundation

protocol UserDefaultsServiceProtocol {
    
    func setBool(_ value: Bool, _ key: String)
    
    func getBool(_ key: String) -> Bool
}

final class UserDefaultsService: UserDefaultsServiceProtocol {
    
    private let userDefaults: UserDefaults = UserDefaults.standard
    
    
    func getBool(_ key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }
    
    func setBool(_ value: Bool, _ key: String) {
        userDefaults.set(value, forKey: key)
    }
}
