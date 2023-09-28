//
//  CreateRecipeViewModel.swift
//  Smetanka
//
//  Created by Димон on 26.09.23.
//

import RealmSwift
import RxSwift
import Foundation

protocol CreateRecipeViewModelProtocol {
    
    var loadingSubject: BehaviorSubject<Bool> { get }
    
    var saveSuccessSubject: PublishSubject<Void> { get }
    
    func createRecipe(recipe: Recipe)
}


final class CreateRecipeViewModel: CreateRecipeViewModelProtocol {
    
    private var storage: LocalStorageServiceProtocol!
    
    var loadingSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    var saveSuccessSubject: PublishSubject<Void> = PublishSubject<Void>()
    
    init() {
        storage = LocalStorageService()
    }
    
    func createRecipe(recipe: Recipe) {
        loadingSubject.onNext(true)
        storage.save(recipe: recipe)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [unowned self] in
            loadingSubject.onNext(true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [unowned self] in
            saveSuccessSubject.on(.completed)
        }
    }
}
