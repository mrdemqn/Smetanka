//
//  FoodNetworkService.swift
//  Smetanka
//
//  Created by Димон on 10.08.23.
//


protocol RecipeServiceProtocol {
    
    func fetchAllRecipes() async throws -> [LocalRecipe]
    
    func fetchRecipe(_ id: String) async throws -> LocalRecipe
}

final class RecipeService: RecipeServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init() {
        networkService = NetworkService()
    }
    
    func fetchAllRecipes() async throws -> [LocalRecipe] {
        do {
            let recipes = try await networkService.get([LocalRecipe].self,
                                                     link: ApiConstants.allRecipes,
                                                     headers: nil)
            return recipes
        } catch {
            throw error
        }
    }
    
    func fetchRecipe(_ id: String) async throws -> LocalRecipe {
        do {
            let recipe = try await networkService.get(LocalRecipe.self,
                                                      link: "\(ApiConstants.recipe)/\(id)",
                                                      headers: nil)
            return recipe
        } catch {
            throw error
        }
    }
}
