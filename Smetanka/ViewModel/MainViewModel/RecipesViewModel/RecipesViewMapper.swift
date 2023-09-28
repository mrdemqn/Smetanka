//
//  RecipesViewMapper.swift
//  Smetanka
//
//  Created by Димон on 15.08.23.
//

import Foundation
import RealmSwift

protocol RecipesViewMapperProtocol {
    
    func mapRealm(realmRecipes: inout [Recipe],
                  recipes: [LocalRecipe])
    
    func mapRealm(recipe: inout Recipe,
                  localRecipe: LocalRecipe)
    
    func mapLocal(recipe: Recipe) -> LocalRecipe
}

final class RecipesViewMapper: RecipesViewMapperProtocol {
    
    
    func mapRealm(realmRecipes: inout [Recipe],
                  recipes: [LocalRecipe]) {
        var mapped: [Recipe] = []
        for recipe in recipes {
            let realmRecipe = Recipe(id: recipe.id,
                                     title: recipe.title,
                                     difficulty: recipe.difficulty,
                                     image: recipe.image,
                                     portion: recipe.portion,
                                     time: recipe.time,
                                     descriptionRecipe: recipe.description,
                                     ingredients: List<String>(),
                                     method: List<String>(),
                                     isFavourite: false,
                                     isMyRecipe: false,
                                     uiImage: recipe.uiImage)
            realmRecipe.ingredients.append(objectsIn: recipe.ingredients ?? [])
            realmRecipe.method.append(objectsIn: recipe.foodMethods)
            mapped.append(realmRecipe)
        }
        realmRecipes = mapped
    }
    
    func mapRealm(recipe: inout Recipe,
                  localRecipe: LocalRecipe) {
        let realmRecipe = Recipe(id: localRecipe.id,
                                 title: localRecipe.title,
                                 difficulty: localRecipe.difficulty,
                                 image: localRecipe.image,
                                 portion: localRecipe.portion,
                                 time: localRecipe.time,
                                 descriptionRecipe: localRecipe.description,
                                 ingredients: List<String>(),
                                 method: List<String>(),
                                 isFavourite: localRecipe.isFavourite ?? false,
                                 isMyRecipe: localRecipe.isMyRecipe ?? false,
                                 uiImage: localRecipe.uiImage)
        realmRecipe.ingredients.append(objectsIn: recipe.ingredients)
        realmRecipe.method.append(objectsIn: recipe.method)
        recipe = realmRecipe
    }
    
    func mapLocal(recipe: Recipe) -> LocalRecipe {
        var methods: [[String: String]] = []
        for (index, method) in recipe.method.enumerated() {
            methods.append(["\(index)": method])
        }
        return LocalRecipe(id: recipe.id,
                           title: recipe.title,
                           difficulty: recipe.difficulty,
                           image: recipe.image,
                           portion: recipe.portion,
                           time: recipe.time,
                           description: recipe.descriptionRecipe,
                           ingredients: Array(recipe.ingredients),
                           method: methods,
                           isFavourite: recipe.isFavourite,
                           isMyRecipe: recipe.isMyRecipe,
                           uiImage: recipe.uiImage)
    }
}
