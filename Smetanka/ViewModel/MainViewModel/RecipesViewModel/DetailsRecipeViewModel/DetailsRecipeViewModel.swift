//
//  DetailsRecipeViewModel.swift
//  Smetanka
//
//  Created by Димон on 15.08.23.
//

import Foundation
import RxSwift

protocol DetailsRecipeViewModelProtocol {
    
    var recipePublish: PublishSubject<Food> { get }
    
    var loadingSubject: BehaviorSubject<Bool> { get }
    
    func fetchRecipe(_ id: String) async
}

final class DetailsRecipeViewModel: DetailsRecipeViewModelProtocol {
    
    private var foodService: FoodServiceProtocol!
    
    init() {
        foodService = FoodService()
    }
    
    var recipePublish = PublishSubject<Food>()
    
    var loadingSubject = BehaviorSubject<Bool>(value: true)
    
    func fetchRecipe(_ id: String) async {
        do {
            let recipe = try await foodService.fetchRecipe(id)
            recipePublish.onNext(recipe)
        } catch {
            print(error)
        }
        loadingSubject.onNext(false)
    }
}
