//
//  LocalizationExtensions.swift
//  Smetanka
//
//  Created by Димон on 2.08.23.
//

import Foundation

extension NSObject {
    
    func localized(of key: Localization, _ comment: String = "") -> String {
        return NSLocalizedString(key.rawValue, comment: comment)
    }
}
