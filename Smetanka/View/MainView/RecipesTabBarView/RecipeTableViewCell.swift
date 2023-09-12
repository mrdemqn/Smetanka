//
//  RecipesTableViewCell.swift
//  Smetanka
//
//  Created by Димон on 10.08.23.
//

import UIKit

final class RecipeTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var backgroundCellView: UIView!
    @IBOutlet private weak var recipeTitleLabel: UILabel!
    @IBOutlet private weak var recipeDifficultyLabel: UILabel!
    @IBOutlet private weak var recipeImageView: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }
    
    @IBAction private func favouriteAction(_ sender: UIButton) {
        
    }
}

extension RecipeTableViewCell {
    
    func configure(title: String, difficulty: String, imageUrl: String) {
        recipeTitleLabel.text = title
        recipeDifficultyLabel.text = "\(localized(of: .difficulty)): \(difficulty)"
        
        recipeImageView.load(from: imageUrl)
    }
}

extension RecipeTableViewCell {
    
    private func setupUI() {
        backgroundCellView.layer.cornerRadius = 20
        backgroundCellView.layer.shadowColor = UIColor.gray.cgColor
        backgroundCellView.layer.shadowOpacity = 0.3
        backgroundCellView.layer.shadowRadius = 10
        backgroundCellView.layer.shadowOffset = CGSize(width: 0, height: 0)
        
        recipeImageView.layer.cornerRadius = 20
    }
}
