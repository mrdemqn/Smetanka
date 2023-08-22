//
//  RecipesViewMapper.swift
//  Smetanka
//
//  Created by Димон on 15.08.23.
//

import Foundation
import CoreData

protocol RecipesViewMapperProtocol {
    
    func mapFoodToFoodCore(_ foods: [Food],
                           context: NSManagedObjectContext,
                           foodCore: inout Set<FoodCore>)
    
    func mapFoodCoreToFood(_ foodCore: NSSet,
                           recipes: inout [Food])
}

final class RecipesViewMapper: RecipesViewMapperProtocol {
    
    func mapFoodToFoodCore(_ foods: [Food],
                           context: NSManagedObjectContext,
                           foodCore: inout Set<FoodCore>) {
        let foodsCore = foods.map { food in
            let foodCore = FoodCore(context: context)
            foodCore.id = food.id
            foodCore.title = food.title
            foodCore.difficulty = food.difficulty
            foodCore.image = food.image
            foodCore.portion = food.portion
            foodCore.time = food.time
            foodCore.recipeDescription = food.description
            foodCore.ingredients = food.ingredients
            foodCore.method = food.method
            return foodCore
        }
        foodCore = Set(foodsCore)
    }
    
    func mapFoodCoreToFood(_ foodCore: NSSet,
                           recipes: inout [Food]) {
        let foods: Set<FoodCore> = Set(_immutableCocoaSet: foodCore)
        
        let mappedRecipes = foods.map { foodCore in
            return Food(id: foodCore.id!,
                        title: foodCore.title!,
                        difficulty: foodCore.difficulty!,
                        image: foodCore.image!,
                        portion: foodCore.portion!,
                        time: foodCore.time!,
                        description: foodCore.recipeDescription!,
                        ingredients: foodCore.ingredients!,
                        method: foodCore.method!)
        }
        
        recipes = mappedRecipes
    }
}
