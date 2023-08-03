//
//  StringExtensions.swift
//  Smetanka
//
//  Created by Димон on 2.08.23.
//

extension String {
    
    var isNotEmpty: Bool {
        !self.isEmpty
    }
    
    var trim: String {
        self.trimmingCharacters(in: .whitespaces)
    }
    
    var isNumbers: Bool {
        self == self.components(separatedBy: .decimalDigits.inverted).joined()
    }
}
