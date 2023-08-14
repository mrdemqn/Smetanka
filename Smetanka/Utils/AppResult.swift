//
//  Result.swift
//  Smetanka
//
//  Created by Димон on 2.08.23.
//

import Foundation

enum AppResult<T, E> {
    
    case success(result: T)
    
    case failure(custom: E, Error? = nil)
}
