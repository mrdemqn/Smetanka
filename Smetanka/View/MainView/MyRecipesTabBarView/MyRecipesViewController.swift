//
//  MyRecipesViewController.swift
//  Smetanka
//
//  Created by Димон on 7.09.23.
//

import UIKit
import RxSwift
import Hero

final class MyRecipesViewController: UIViewController {
    
    private var viewModel: MyRecipeViewModelProtocol!
    
    private var collectionView: UICollectionView!
    
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isHeroEnabled = true
        navigationController?.heroNavigationAnimationType = .selectBy(presenting: .zoom, dismissing: .zoomOut)
        viewModel = MyRecipeViewModel()
        bindViewModel()
        
        setupNavigationBar()
        configureLayout()
        
        collectionView.isHeroEnabled = true
        collectionView.heroModifiers = [.cascade]
        
        Task {
            await viewModel.fetchMyRecipes()
        }
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
        let layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.backgroundColor = .background
        
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
    
    func setupNavigationBar() {
        navigationItem.title = localized(of: .myRecipes)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

private extension MyRecipesViewController {
    
    func bindViewModel() {
        viewModel.recipesSubject.subscribe { _ in
            DispatchQueue.main.async { [unowned self] in
                collectionView.reloadData()
            }
        }.disposed(by: disposeBag)
    }
}

extension MyRecipesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: Xibs.recipeCollectionCell,
                                 for: indexPath) as? RecipeCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }
}

extension MyRecipesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? RecipeCollectionViewCell else { return }
        
        cell.heroID = "ImageID"
        
        let recipe = viewModel.recipes[indexPath.item]
        
        cell.configureContent(title: recipe.title,
                              difficulty: recipe.difficulty,
                              imageLink: recipe.image)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.width / 2) - 15
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 5, left: 10, bottom: 5, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

extension MyRecipesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = DetailsRecipeViewController()
        let recipe = viewModel.recipes[indexPath.item]
        controller.recipeId = recipe.id
        push(of: controller, hideBar: true)
    }
}
