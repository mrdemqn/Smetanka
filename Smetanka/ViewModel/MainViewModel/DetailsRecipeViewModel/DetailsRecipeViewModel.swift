//
//  DetailsRecipeViewModel.swift
//  Smetanka
//
//  Created by Димон on 15.08.23.
//

import Foundation
import RxSwift

protocol DetailsRecipeViewModelProtocol {
    
    var recipe: Food? { get }
    
    var recipePublish: PublishSubject<Food> { get }
    
    func fetchRecipe()
}

final class DetailsRecipeViewModel: DetailsRecipeViewModelProtocol {
    
    var recipe: Food? {
        didSet {
            
        }
    }
    
    var recipePublish = PublishSubject<Food>()
    
    func fetchRecipe() {
        
    }
}
