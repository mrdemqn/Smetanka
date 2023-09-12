//
//  MyRecipeViewModel.swift
//  Smetanka
//
//  Created by Димон on 7.09.23.
//

protocol MyRecipeViewModelProtocol {
    
    var recipes: [String] { get }
}

final class MyRecipeViewModel: MyRecipeViewModelProtocol {
    
    var recipes: [String] = ["First", "Second", "First", "Second", "First", "Second", "First", "Second"]
}
