//
//  RecipesViewModel.swift
//  Smetanka
//
//  Created by Димон on 10.08.23.
//

import RxSwift

protocol RecipesViewModelProtocol {
    
    var recipes: [Food] { get }
    
    var loadingSubject: BehaviorSubject<Bool> { get }
    
    var recipesSubject: PublishSubject<Void> { get }
    
    func fetchRecipes() async
}

final class RecipesViewModel: RecipesViewModelProtocol {
    
    private let foodService: FoodServiceProtocol
    
    var recipes: [Food] = [] {
        didSet {
            recipesSubject.on(.completed)
        }
    }
    
    var loadingSubject: BehaviorSubject<Bool> = BehaviorSubject(value: true)
    
    var recipesSubject: PublishSubject<Void> = PublishSubject()
    
    init() {
        foodService = FoodService()
    }
    
    func fetchRecipes() async {
        do {
            let foods = try await foodService.fetchAllRecipes()
            recipes = foods
        } catch {
            print("Has Error: \(error)")
        }
        loadingSubject.onNext(false)
    }
}
