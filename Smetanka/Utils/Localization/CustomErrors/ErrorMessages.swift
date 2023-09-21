//
//  ErrorMessages.swift
//  Smetanka
//
//  Created by Димон on 20.09.23.
//

import Foundation
import FirebaseAuth

final class ErrorMessages {
    
    static func describeFBCode(_ code: AuthErrorCode.Code) -> (title: String, message: String)? {
        
        switch (code) {
            case .unverifiedEmail:
                return getDescribe(title: .unverifiedEmailTitle, message: .unverifiedEmailMessage)
            default: return nil
        }
    }
    
    static private func localized(of key: Localization, _ comment: String = "") -> String {
        return NSLocalizedString(key.rawValue, comment: comment)
    }
    
    static private func getDescribe(title keyTitle: Localization,
                                    message keyMessage: Localization) -> (title: String, message: String) {
        return (localized(of: keyTitle), message: localized(of: keyMessage))
    }
}
