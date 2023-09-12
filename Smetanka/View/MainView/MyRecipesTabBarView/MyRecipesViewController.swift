//
//  MyRecipesViewController.swift
//  Smetanka
//
//  Created by Димон on 7.09.23.
//

import UIKit

final class MyRecipesViewController: UIViewController {
    
    let imageLink = "https://helpx.adobe.com/content/dam/help/en/photoshop/using/convert-color-image-black-white/jcr_content/main-pars/before_and_after/image-before/Landscape-Color.jpg"
    
    private var viewModel: MyRecipeViewModelProtocol!
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MyRecipeViewModel()
        
        configureLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareLayout()
    }
}

/// MARK - Конфигурация CollectionView
private extension MyRecipesViewController {
    
    func configureLayout() {
        configureSuperView()
        configureCollectionView()
    }
    
    func prepareLayout() {
        prepareCollectionView()
    }
    
    func configureSuperView() {
        view.backgroundColor = .background
    }
    
    func configureCollectionView() {
        let layout = UICollectionViewLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .gray
        
        collectionView.register(RecipeCollectionViewCell.self,
                                forCellWithReuseIdentifier: Xibs.recipeCollectionCell)
    }
    
    func prepareCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

extension MyRecipesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: Xibs.recipeCollectionCell,
                                 for: indexPath) as? RecipeCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configureContent(title: viewModel.recipes[0],
                              difficulty: viewModel.recipes[1],
                              imageLink: imageLink)
        
        return cell
    }
}

extension MyRecipesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let size = (collectionView.frame.width / 2) - 5
        print("Size")
        return CGSize(width: 50, height: 50)
    }
}

extension MyRecipesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
}
