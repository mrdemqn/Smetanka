//
//  FoodNetworkService.swift
//  Smetanka
//
//  Created by Димон on 10.08.23.
//


protocol FoodServiceProtocol {
    
    func fetchAllRecipes() async throws -> [Food]
    
    func fetchRecipe(_ id: String) async throws -> Food
}

final class FoodService: FoodServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init() {
        networkService = NetworkService()
    }
    
    func fetchAllRecipes() async throws -> [Food] {
        do {
            let foods = try await networkService.get([Food].self,
                                                     link: ApiConstants.allRecipes,
                                                     headers: nil)
            return foods
        } catch {
            throw error
        }
    }
    
    func fetchRecipe(_ id: String) async throws -> Food {
        do {
            let recipe = try await networkService.get(Food.self,
                                                      link: "\(ApiConstants.recipe)/\(id)",
                                                      headers: nil)
            return recipe
        } catch {
            throw error
        }
    }
}
