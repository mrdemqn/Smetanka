//
//  DetailsRecipeViewModel.swift
//  Smetanka
//
//  Created by Димон on 15.08.23.
//

import Foundation
import RxSwift

protocol DetailsRecipeViewModelProtocol {
    
    var recipePublish: PublishSubject<LocalRecipe> { get }
    
    var loadingSubject: BehaviorSubject<Bool> { get }
    
    var favouriteButtonSubject: PublishSubject<Bool> { get }
    
    var failureSubject: PublishSubject<Void> { get }
    
    func fetchLocalRecipe(_ id: String) async
    
    func fetchLocalIfExists(_ id: String) async
    
    func changeFavourite()
}

final class DetailsRecipeViewModel: DetailsRecipeViewModelProtocol {
    
    private var foodService: RecipeServiceProtocol!
    
    private var storage: LocalStorageServiceProtocol!
    
    private var mapper: RecipesViewMapperProtocol!
    
    private var currentRecipe: LocalRecipe?
    
    private var isFavourite: Bool = false
    
    init() {
        foodService = RecipeService()
        storage = LocalStorageService()
        mapper = RecipesViewMapper()
    }
    
    var recipePublish = PublishSubject<LocalRecipe>()
    
    var loadingSubject = BehaviorSubject<Bool>(value: true)
    
    var favouriteButtonSubject = PublishSubject<Bool>()
    
    var failureSubject: PublishSubject<Void> = PublishSubject()
    
    func fetchLocalRecipe(_ id: String) async {
        DispatchQueue.main.async { [unowned self] in
            let recipe = storage.fetch(id)
            
            guard let recipe = recipe else {
                return favouriteButtonSubject.onNext(false)
            }
            let local = mapper.mapLocal(recipe: recipe)
            recipePublish.onNext(local)
            currentRecipe = local
            favouriteButtonSubject.onNext(recipe.isFavourite)
            loadingSubject.onNext(false)
        }
    }
    
    func fetchLocalIfExists(_ id: String) async {
        DispatchQueue.main.async { [unowned self] in
            let recipe = storage.fetch(id)
            
            guard let recipe = recipe else {
                Task {
                    do {
                        let recipe = try await foodService.fetchRecipe(id)
                        recipePublish.onNext(recipe)
                        currentRecipe = recipe
                        favouriteButtonSubject.onNext(recipe.isFavourite ?? false)
                        loadingSubject.onNext(false)
                    } catch {
                        print(error)
                    }
                }
                return
            }
            
            let local = mapper.mapLocal(recipe: recipe)
            recipePublish.onNext(local)
            currentRecipe = local
            favouriteButtonSubject.onNext(recipe.isFavourite)
            loadingSubject.onNext(false)
        }
    }
    
    func changeFavourite() {
        guard let localRecipe = currentRecipe else { return }
        var recipe = Recipe()
        let unwrap = localRecipe.isFavourite ?? false
        let isFavourite = !unwrap
        mapper.mapRealm(recipe: &recipe, localRecipe: localRecipe)
        storage.updateIsFavourite(recipe: recipe,
                                  isFavourite: isFavourite) { recipe in
            let local = self.mapper.mapLocal(recipe: recipe)
            self.currentRecipe = local
            self.favouriteButtonSubject.onNext(recipe.isFavourite)
        }
    }
    
    private func fetchRecipe(_ id: String) async {
        do {
            let recipe = try await foodService.fetchRecipe(id)
            recipePublish.onNext(recipe)
            currentRecipe = recipe
        } catch {
            failureSubject.on(.error(error))
        }
        loadingSubject.onNext(false)
    }
}
