//
//  Result.swift
//  Smetanka
//
//  Created by Димон on 2.08.23.
//

import Foundation

enum Result<T> {
    
    case success(T)
    
    case failure(CustomError, Error? = nil)
}
