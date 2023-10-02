//
//  CoreDataService.swift
//  Smetanka
//
//  Created by Димон on 2.08.23.
//

import RealmSwift
import Foundation

protocol LocalStorageServiceProtocol {
    
    func fetch(completion: @escaping ([Recipe]) -> Void)
    
    func fetch(_ id: String) -> Recipe?
    
    func fetchFavourites(completion: @escaping ([Recipe]) -> Void)
    
    func save(recipe: Recipe)
    
    func updateIsFavourite(recipe: Recipe,
                           isFavourite: Bool,
                           completion: @escaping (Recipe) -> Void)
    
    func observeFavourites(_ update: @escaping ([Recipe]) -> Void)
    
    func fetchMyRecipes(completion: @escaping ([Recipe]) -> Void)
    
    func updateIsMyRecipes(recipe: Recipe,
                           isFavourite: Bool,
                           completion: @escaping (Recipe) -> Void)
    
    func observeMyRecipes(_ update: @escaping ([Recipe]) -> Void)
    
    func deleteObjects(recipes: [Recipe])
}

final class LocalStorageService: LocalStorageServiceProtocol {
    
    private var realm: Realm!
    
    private var favouritesObserveToken: NotificationToken?
    
    private var myRecipesObserveToken: NotificationToken?
    
    private var favouritesResult: Results<Recipe>?
    
    private var myRecipesResult: Results<Recipe>?
    
    init() {
        var config = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {}
            })
        config.deleteRealmIfMigrationNeeded = true
        
        Realm.Configuration.defaultConfiguration = config
        
        realm = try! Realm()
    }
    
    func save(recipe: Recipe) {
        do {
            try realm.write {
                realm.add(recipe)
            }
        } catch { }
    }
    
    func fetch(completion: @escaping ([Recipe]) -> Void) {
        let results = realm.objects(Recipe.self)
        var recipes: [Recipe] = []
        for result in results {
            recipes.append(result)
        }
        
        completion(recipes)
    }
    
    func fetch(_ id: String) -> Recipe? {
        let recipe = realm.object(ofType: Recipe.self, forPrimaryKey: id)
        return recipe
    }
    
    func deleteObjects(recipes: [Recipe]) {
        recipes.forEach { recipe in
            try! realm.write {
                realm.delete(recipe)
            }
        }
    }
    
    func fetchFavourites(completion: @escaping ([Recipe]) -> Void) {
        DispatchQueue.main.async {
            self.favouritesResult = self.realm.objects(Recipe.self)
            guard let results = self.favouritesResult else { return }
            var recipes = self.filterMapToArrayFavourites(results: results)
            
            completion(recipes)
        }
    }
    
    func updateIsFavourite(recipe: Recipe,
                           isFavourite: Bool,
                           completion: @escaping (Recipe) -> Void) {
        DispatchQueue.main.async { [unowned self] in
            do {
                let result = self.realm.object(ofType: Recipe.self, forPrimaryKey: recipe.id)
                
                if result == nil {
                    recipe.isFavourite = isFavourite
                    save(recipe: recipe)
                    completion(recipe)
                } else {
                    try realm.write {
                        result!.isFavourite = isFavourite
                    }
                    completion(recipe)
                }
            } catch {}
        }
    }
    
    func observeFavourites(_ update: @escaping ([Recipe]) -> Void) {
        favouritesObserveToken = favouritesResult?.observe { changes in
            switch changes {
                case .initial(_): break
                case .error(_): break
                case .update(let recipes, deletions: _, insertions: _, modifications: _):
                    let newRecipes = self.filterMapToArrayFavourites(results: recipes)
                    update(newRecipes)
            }
        }
    }
    
    func fetchMyRecipes(completion: @escaping ([Recipe]) -> Void) {
        DispatchQueue.main.async {
            self.favouritesResult = self.realm.objects(Recipe.self)
            guard let results = self.favouritesResult else { return }
            var recipes = self.filterMapToArrayMyRecipes(results: results)
            
            completion(recipes)
        }
    }
    
    func updateIsMyRecipes(recipe: Recipe,
                           isFavourite: Bool,
                           completion: @escaping (Recipe) -> Void) {
        DispatchQueue.main.async { [unowned self] in
            do {
                let result = self.realm.object(ofType: Recipe.self, forPrimaryKey: recipe.id)
                
                if result == nil {
                    recipe.isFavourite = isFavourite
                    save(recipe: recipe)
                    completion(recipe)
                } else {
                    try realm.write {
                        result!.isFavourite = isFavourite
                    }
                    completion(recipe)
                }
            } catch {}
        }
    }
    
    func observeMyRecipes(_ update: @escaping ([Recipe]) -> Void) {
        myRecipesObserveToken = myRecipesResult?.observe { changes in
            switch changes {
                case .initial(_): break
                case .error(_): break
                case .update(let recipes, deletions: _, insertions: _, modifications: _):
                    let newRecipes = self.filterMapToArrayMyRecipes(results: recipes)
                    update(newRecipes)
            }
        }
    }
    
    private func filterMapToArrayFavourites(results: Results<Recipe>) -> [Recipe] {
            var recipes: [Recipe] = []
            let filtered = results.where { query in
                query.isFavourite
            }
            for result in filtered {
                recipes.append(result)
            }
        return recipes
    }
    
    private func filterMapToArrayMyRecipes(results: Results<Recipe>) -> [Recipe] {
            var recipes: [Recipe] = []
            let filtered = results.where { query in
                query.isMyRecipe
            }
            for result in filtered {
                recipes.append(result)
            }
        return recipes
    }
    
    deinit {
        favouritesObserveToken?.invalidate()
    }
}
