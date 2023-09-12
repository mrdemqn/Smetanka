//
//  FavouriteViewModel.swift
//  Smetanka
//
//  Created by Димон on 7.09.23.
//

import RxSwift

protocol FavouriteViewModelProtocol {
    
    var recipes: [Food] { get }
    
    var loadingSubject: BehaviorSubject<Bool> { get }
    
    var recipesSubject: PublishSubject<Void> { get }
    
    func fetchRecipes() async
}

final class FavouriteViewModel: FavouriteViewModelProtocol {
    
    private let foodService: FoodServiceProtocol
    
    var loadingSubject: BehaviorSubject<Bool> = BehaviorSubject(value: true)
    
    var recipesSubject: PublishSubject<Void> = PublishSubject()
    
    init() {
        foodService = FoodService()
    }
    
    var recipes: [Food] = [] {
        didSet {
            recipesSubject.on(.completed)
        }
    }
    
    func fetchRecipes() async {
        loadingSubject.onNext(true)
        do {
            let foods = try await foodService.fetchAllRecipes()
            recipes = foods
        } catch {
            print("Has Error: \(error)")
        }
        loadingSubject.onNext(false)
    }
}
