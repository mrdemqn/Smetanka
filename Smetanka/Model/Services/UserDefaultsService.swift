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
    
    func setInt(_ value: Int, _ key: String)
    
    func getInt(_ key: String) -> Int
}

final class UserDefaultsService: UserDefaultsServiceProtocol {
    
    private let userDefaults: UserDefaults = UserDefaults.standard
    
    
    func getBool(_ key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }
    
    func setBool(_ value: Bool, _ key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    func setInt(_ value: Int, _ key: String) {
        userDefaults.set(value, forKey: key)
    }
    
    func getInt(_ key: String) -> Int {
        return userDefaults.integer(forKey: key)
    }
}
