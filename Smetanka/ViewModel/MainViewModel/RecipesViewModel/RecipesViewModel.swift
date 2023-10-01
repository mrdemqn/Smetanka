//
//  RecipesViewModel.swift
//  Smetanka
//
//  Created by Димон on 10.08.23.
//

import RxSwift
import RealmSwift
import Foundation

protocol RecipesViewModelProtocol {
    
    var recipes: [Recipe] { get }
    
    var loadingSubject: BehaviorSubject<Bool> { get }
    
    var recipesSubject: PublishSubject<Void> { get }
    
    var failureSubject: PublishSubject<Void> { get }
    
    func fetchRecipes() async
}

final class RecipesViewModel: RecipesViewModelProtocol {
    
    private let foodService: RecipeServiceProtocol
    
    private let storage: LocalStorageServiceProtocol
    
    private let networkService: NetworkServiceProtocol
    
    private let mapper: RecipesViewMapperProtocol
    
    var recipes: [Recipe] = [] {
        didSet {
            recipesSubject.on(.completed)
        }
    }
    
    var loadingSubject: BehaviorSubject<Bool> = BehaviorSubject(value: true)
    
    var recipesSubject: PublishSubject<Void> = PublishSubject()
    
    var failureSubject: PublishSubject<Void> = PublishSubject()
    
    init() {
        foodService = RecipeService()
        storage = LocalStorageService()
        networkService = NetworkService()
        mapper = RecipesViewMapper()
    }
    
    func fetchRecipes() async {
        loadingSubject.onNext(true)
        
        await self.fetchRecipesNetwork()
        
        loadingSubject.onNext(false)
    }
    
    private func fetchRecipesNetwork() async {
        do {
            let recipes = try await foodService.fetchAllRecipes()
            mapper.mapRealm(realmRecipes: &self.recipes, recipes: recipes)
        } catch {
            failureSubject.on(.error(error))
        }
    }
}
