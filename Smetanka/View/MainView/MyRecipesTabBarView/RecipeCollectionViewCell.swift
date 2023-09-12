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
        print(#function)
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        prepareLayout()
    }
    
    func configureContent(title: String,
                          difficulty: String,
                          imageLink: String) {
        titleLabel.text = title
        difficultyLabel.text = difficulty
        imageView.load(from: imageLink)
    }
}

private extension RecipeCollectionViewCell {
    
    func configureLayout() {
        print(#function)
        configureBackgroundCellView()
        configureImageView()
    }
    
    func prepareLayout() {
        print(#function)
        prepareBackgroundCellView()
        prepareImageView()
    }
    
    func configureBackgroundCellView() {
        backgroundCellView.translatesAutoresizingMaskIntoConstraints = false
        backgroundCellView.backgroundColor = .red
    }
    
    func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
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
            imageView.bottomAnchor.constraint(equalTo: backgroundCellView.bottomAnchor),
        ])
    }
}
