//
//  RecipesViewModel.swift
//  Smetanka
//
//  Created by Димон on 10.08.23.
//

import RxSwift
import Foundation

protocol RecipesViewModelProtocol {
    
    var recipes: [Food] { get }
    
    var loadingSubject: BehaviorSubject<Bool> { get }
    
    var recipesSubject: PublishSubject<Void> { get }
    
    func fetchRecipes() async
    
    func translate() async
}

final class RecipesViewModel: RecipesViewModelProtocol {
    
    private let foodService: FoodServiceProtocol
    
    private let localStorage: LocalStorageServiceProtocol
    
    private let mapper: RecipesViewMapperProtocol
    
    private let networkService: NetworkServiceProtocol
    
    var recipes: [Food] = [] {
        didSet {
            recipesSubject.on(.completed)
        }
    }
    
    var recipesCore: Set<FoodCore> = []
    
    var loadingSubject: BehaviorSubject<Bool> = BehaviorSubject(value: true)
    
    var recipesSubject: PublishSubject<Void> = PublishSubject()
    
    init() {
        foodService = FoodService()
        localStorage = LocalStorageService()
        mapper = RecipesViewMapper()
        networkService = NetworkService()
    }
    
    func fetchRecipes() async {
        loadingSubject.onNext(true)
//        let hasLocalData = fetchRecipesLocal()
        
//        if !hasLocalData {
            await fetchRecipesNetwork()
//        }
        loadingSubject.onNext(false)
    }
    
    private func fetchRecipesNetwork() async {
        do {
            let foods = try await foodService.fetchAllRecipes()
            recipes = foods
//            DispatchQueue.global(qos: .background).async { [weak self] in
//                self?.localStorage.save(FoodCore.self) { context in
//                    guard let self = self else { return }
//                    self.mapper.mapFoodToFoodCore(self.recipes,
//                                             context: context,
//                                             foodCore: &self.recipesCore)
//                    let foodsCore = FoodsCore(context: context)
//                    foodsCore.foods = NSSet(object: self.recipesCore)
//                }
//                self?.localStorage.save(FoodsCore.self) { context in
//                    guard let self = self else { return }
//                    let foodsCore = FoodsCore(context: context)
//                    foodsCore.foods = NSSet(object: self.recipesCore)
//                }
//            }
        } catch {
            print("Has Error: \(error)")
        }
    }
    
    private func fetchRecipesLocal() -> Bool {
        let foodsCore = localStorage.fetch(FoodsCore.self)
        
        if foodsCore.isEmpty { return false }
        
        guard let foodsCoreLocal = foodsCore.first!.foods else { return false }
        
        mapper.mapFoodCoreToFood(foodsCoreLocal,
                                 recipes: &recipes)
        recipes.forEach { recipe in
            print("Recipes: \(recipe.title)")
        }
        return true
    }
    
    func translate() async {
        
        let text = await networkService.translate(text: "Could you lie down?")
        print("TranslatedText: \(text)")
    }
}
