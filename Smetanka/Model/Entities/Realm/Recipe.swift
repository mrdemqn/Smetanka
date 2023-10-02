//
//  Recipe.swift
//  Smetanka
//
//  Created by Димон on 26.09.23.
//

import RealmSwift
import Foundation

final class Recipe: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var difficulty: String
    @Persisted var image: String
    @Persisted var portion: String?
    @Persisted var time: String?
    @Persisted var descriptionRecipe: String?
    @Persisted var ingredients: List<String>
    @Persisted var method: List<String>
    
    @Persisted var isFavourite: Bool = false
    @Persisted var isMyRecipe: Bool = false
    
    convenience init(id: String,
                     title: String,
                     difficulty: String,
                     image: String,
                     portion: String?,
                     time: String?,
                     descriptionRecipe: String?,
                     ingredients: List<String>,
                     method: List<String>,
                     isFavourite: Bool,
                     isMyRecipe: Bool) {
        self.init()
        self.id = id
        self.title = title
        self.difficulty = difficulty
        self.image = image
        self.portion = portion
        self.time = time
        self.descriptionRecipe = descriptionRecipe
        self.ingredients = ingredients
        self.method = method
        self.isFavourite = isFavourite
        self.isMyRecipe = isMyRecipe
    }
}
