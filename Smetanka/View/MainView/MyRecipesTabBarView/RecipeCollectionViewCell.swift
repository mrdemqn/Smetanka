//
//  Cell.swift
//  Smetanka
//
//  Created by Димон on 12.09.23.
//

import UIKit

final class RecipeCollectionViewCell: UICollectionViewCell {
    
    private let backgroundCellView = UIView()
    private let imageView = UIImageView()
    
    private let titleLabel = UILabel()
    private let difficultyLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
        prepareLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContent(title: String,
                          difficulty: String,
                          imageLink: String) {
        titleLabel.text = title
        difficultyLabel.text = "\(localized(of: .difficulty)): \(difficulty)"
        imageView.load(from: imageLink)
    }
}

private extension RecipeCollectionViewCell {
    
    func configureLayout() {
        configureSuperView()
        configureBackgroundCellView()
        configureImageView()
        configureTitleLabel()
        configureDifficultyLabel()
    }
    
    func prepareLayout() {
        prepareBackgroundCellView()
        prepareImageView()
        prepareTitleLabel()
        prepareDifficultyLabel()
    }
    
    func configureSuperView() {
        backgroundColor = .clear
    }
    
    func configureBackgroundCellView() {
        backgroundCellView.translatesAutoresizingMaskIntoConstraints = false
        backgroundCellView.backgroundColor = .backgroundTableViewCell
        backgroundCellView.layer.cornerRadius = 20
    }
    
    func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 20
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.layer.masksToBounds = true
    }
    
    func configureTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .helveticaNeueFont(12, weight: .medium)
        titleLabel.lineBreakMode = .byTruncatingMiddle
    }
    
    func configureDifficultyLabel() {
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        difficultyLabel.font = .helveticaNeueFont(10, weight: .medium)
        difficultyLabel.lineBreakMode = .byTruncatingMiddle
    }
    
    func prepareBackgroundCellView() {
        addSubview(backgroundCellView)
        
        NSLayoutConstraint.activate([
            backgroundCellView.topAnchor.constraint(equalTo: topAnchor),
            backgroundCellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundCellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundCellView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func prepareImageView() {
        backgroundCellView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: backgroundCellView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: backgroundCellView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: backgroundCellView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: bounds.height * 0.7),
        ])
    }
    
    func prepareTitleLabel() {
        backgroundCellView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: backgroundCellView.leadingAnchor, constant: 5),
            titleLabel.trailingAnchor.constraint(equalTo: backgroundCellView.trailingAnchor, constant: -5),
        ])
    }
    
    func prepareDifficultyLabel() {
        backgroundCellView.addSubview(difficultyLabel)
        
        NSLayoutConstraint.activate([
            difficultyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            difficultyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            difficultyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            difficultyLabel.bottomAnchor.constraint(equalTo: backgroundCellView.bottomAnchor, constant: -10),
        ])
    }
}
