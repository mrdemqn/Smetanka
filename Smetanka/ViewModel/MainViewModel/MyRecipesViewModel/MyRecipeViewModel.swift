//
//  MyRecipeViewModel.swift
//  Smetanka
//
//  Created by Димон on 7.09.23.
//

import RxSwift

protocol MyRecipeViewModelProtocol {
    
    var recipes: [Recipe] { get }
    
    var loadingSubject: BehaviorSubject<Bool> { get }
    
    var recipesSubject: PublishSubject<Void> { get }
    
    func fetchMyRecipes()
    
    func observe()
}

final class MyRecipeViewModel: MyRecipeViewModelProtocol {
    
    private let storage: LocalStorageServiceProtocol!
    
    var recipes: [Recipe] = [] {
        didSet {
            recipesSubject.on(.completed)
        }
    }
    
    init() {
        storage = LocalStorageService()
    }
    
    var loadingSubject: BehaviorSubject<Bool> = BehaviorSubject(value: true)
    
    var recipesSubject: PublishSubject<Void> = PublishSubject()
    
    func fetchMyRecipes() {
        loadingSubject.onNext(true)
        storage.fetchMyRecipes { recipes in
            self.recipes = recipes
        }
        loadingSubject.onNext(false)
    }
    
    func observe() {
        storage.observeMyRecipes { recipes in
            self.recipes = recipes
        }
    }
}
