//
//  FavouriteViewModel.swift
//  Smetanka
//
//  Created by Димон on 7.09.23.
//

import RxSwift

protocol FavouriteViewModelProtocol {
    
    var recipes: [Recipe] { get }
    
    var loadingSubject: BehaviorSubject<Bool> { get }
    
    var recipesSubject: PublishSubject<Void> { get }
    
    func fetchRecipes()
    
    func observeFavourites()
}

final class FavouriteViewModel: FavouriteViewModelProtocol {
    
    private let storage: LocalStorageServiceProtocol
    
    var loadingSubject: BehaviorSubject<Bool> = BehaviorSubject(value: true)
    
    var recipesSubject: PublishSubject<Void> = PublishSubject()
    
    init() {
        storage = LocalStorageService()
    }
    
    var recipes: [Recipe] = [] {
        didSet {
            recipesSubject.on(.completed)
        }
    }
    
    func fetchRecipes() {
        loadingSubject.onNext(true)

        storage.fetchFavourites { recipes in
            self.recipes = recipes
            self.loadingSubject.onNext(false)
        }
    }
    
    func observeFavourites() {
        storage.observeFavourites { result in
            self.recipes = result
        }
    }
}
