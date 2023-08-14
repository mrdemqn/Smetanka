//
//  ApiConstants.swift
//  Smetanka
//
//  Created by Димон on 10.08.23.
//


final class ApiConstants {
    
    static let apiKeyHeaderField = "X-RapidAPI-Key"
    static let apiKeyValue = "456b1b44cfmsh78d6d21f1119f35p1a5747jsn47607ec28848"
    static let apiHostHeaderField = "X-RapidAPI-Host"
    static let apiHostValue = "the-mexican-food-db.p.rapidapi.com"
    
    
    static private let baseUrl = "https://the-mexican-food-db.p.rapidapi.com"
    
    static let allRecipes = "\(baseUrl)"
    static let recipe = "\(baseUrl)"
    
}
