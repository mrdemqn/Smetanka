//
//  MyRecipeViewModel.swift
//  Smetanka
//
//  Created by Димон on 7.09.23.
//

import RxSwift

protocol MyRecipeViewModelProtocol {
    
    var recipes: [Food] { get }
    
    var loadingSubject: BehaviorSubject<Bool> { get }
    
    var recipesSubject: PublishSubject<Void> { get }
    
    func fetchMyRecipes()
}

final class MyRecipeViewModel: MyRecipeViewModelProtocol {
    
    private let foodService: FoodServiceProtocol
    
    var recipes: [Food] = [] {
        didSet {
            recipesSubject.on(.completed)
        }
    }
    
    init() {
        foodService = FoodService()
    }
    
    var loadingSubject: BehaviorSubject<Bool> = BehaviorSubject(value: true)
    
    var recipesSubject: PublishSubject<Void> = PublishSubject()
    
    func fetchMyRecipes() {
        loadingSubject.onNext(true)
        
        loadingSubject.onNext(false)
    }
}
