//
//  Food.swift
//  Smetanka
//
//  Created by Димон on 3.08.23.
//

struct Food: Codable {

    let id: String
    let title: String
    let difficulty: String
    let image: String
    let portion: String?
    let time: String?
    let description: String?
    let ingredients: [String]?
    let method: [[String: String]]?
}

extension Food {
    
    var foodMethods: [String] {
        return parseMethods()
    }
    
    private func parseMethods() -> [String] {
        var methodsFoods: [String] = []
        
        method?.forEach { dictionaryOfMethods in
            dictionaryOfMethods.forEach { key, value in
                methodsFoods.append(value)
            }
        }
        return methodsFoods
    }
}
