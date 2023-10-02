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
    
    private let recipesNotFoundLabel = UILabel()
    
    private let disposeBag = DisposeBag()
    
    private let itemsPerRow: CGFloat = 2
    private let sectionInserts = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isHeroEnabled = true
        navigationController?.heroNavigationAnimationType = .selectBy(presenting: .zoom,
                                                                      dismissing: .zoomOut)
        
        viewModel = MyRecipeViewModel()
        bindViewModel()
        
        setupNavigationBar()
        configureLayout()
        
        collectionView.isHeroEnabled = true
        collectionView.heroModifiers = [.cascade]
        
        viewModel.fetchMyRecipes()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            viewModel.observe()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
        recipesNotFoundLabel.isHidden = !viewModel.recipes.isEmpty
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
        configureRecipesNotFoundLabel()
    }
    
    func prepareLayout() {
        prepareCollectionView()
        prepareRecipesNotFoundLabel()
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
    
    func configureRecipesNotFoundLabel() {
        recipesNotFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        recipesNotFoundLabel.text = localized(of: .favouritesNotFound)
        recipesNotFoundLabel.font = .helveticaNeueFont(20, weight: .bold)
        recipesNotFoundLabel.numberOfLines = 0
        recipesNotFoundLabel.textAlignment = .center
        recipesNotFoundLabel.isHidden = !viewModel.recipes.isEmpty
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
    func prepareRecipesNotFoundLabel() {
        view.addSubview(recipesNotFoundLabel)
        
        NSLayoutConstraint.activate([
            recipesNotFoundLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            recipesNotFoundLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            recipesNotFoundLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            recipesNotFoundLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
        ])
    }
    
    func setupNavigationBar() {
        navigationItem.title = localized(of: .myRecipes)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(showCreateRecipe))
    }
}

private extension MyRecipesViewController {
    
    func bindViewModel() {
        viewModel.recipesSubject.subscribe { _ in
            DispatchQueue.main.async { [unowned self] in
                collectionView.reloadData()
                recipesNotFoundLabel.isHidden = !viewModel.recipes.isEmpty
            }
        }.disposed(by: disposeBag)
    }
    
    @objc func showCreateRecipe() {
        let controller = CreateRecipeViewController()
        push(of: controller, hideBar: true)
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
                              imageUrl: recipe.image)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingWidth = sectionInserts.left * (itemsPerRow + 1)
        let availableWidth = collectionView.frame.width - paddingWidth
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInserts
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInserts.left
    }
}

extension MyRecipesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = DetailsRecipeViewController()
        let recipe = viewModel.recipes[indexPath.item]
        controller.recipeId = recipe.id
        controller.fromMyRecipe = true
        push(of: controller, hideBar: true)
    }
}
