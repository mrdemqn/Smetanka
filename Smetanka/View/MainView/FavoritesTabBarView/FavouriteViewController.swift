//
//  FavouriteViewController.swift
//  Smetanka
//
//  Created by Димон on 7.09.23.
//

import UIKit
import RxSwift

final class FavouriteViewController: UIViewController {
    
    private var viewModel: FavouriteViewModelProtocol!
    
    private let tableView = UITableView()
    
    private let recipesNotFoundLabel = UILabel()
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FavouriteViewModel()
        
        bindViewModel()
        
        setupNavigationBar()
        
        configureLayout()
        
        viewModel.fetchRecipes()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [unowned self] in
            viewModel.observeFavourites()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        recipesNotFoundLabel.isHidden = !viewModel.recipes.isEmpty
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareLayout()
    }
}

/// MARK - Конфигурация TableView
private extension FavouriteViewController {
    
    func configureLayout() {
        configureSuperView()
        configureTableView()
        configureRecipesNotFoundLabel()
    }
    
    func prepareLayout() {
        prepareTableView()
        prepareRecipesNotFoundLabel()
    }
    
    func configureSuperView() {
        view.backgroundColor = .background
    }
    
    func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let nib = UINib(nibName: "\(RecipeTableViewCell.self)", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Xibs.recipeCell)
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .background
    }
    
    func configureRecipesNotFoundLabel() {
        recipesNotFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        recipesNotFoundLabel.text = localized(of: .favouritesNotFound)
        recipesNotFoundLabel.font = .helveticaNeueFont(20, weight: .bold)
        recipesNotFoundLabel.numberOfLines = 0
        recipesNotFoundLabel.textAlignment = .center
        recipesNotFoundLabel.isHidden = !viewModel.recipes.isEmpty
    }
    
    func prepareTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        navigationItem.title = localized(of: .favourites)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}


private extension FavouriteViewController {
    
    func bindViewModel() {
        viewModel.recipesSubject.subscribe { _ in
            DispatchQueue.main.async { [unowned self] in
                tableView.reloadData()
            }
        }.disposed(by: disposeBag)
    }
}

extension FavouriteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Xibs.recipeCell, for: indexPath)
        return cell
    }
}

extension FavouriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cell = cell as? RecipeTableViewCell else { return }
        
        let recipe = viewModel.recipes[indexPath.item]
        
        cell.configure(title: recipe.title,
                       difficulty: recipe.difficulty,
                       imageUrl: recipe.image)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = DetailsRecipeViewController()
        let recipe = viewModel.recipes[indexPath.item]
        controller.recipeId = recipe.id
        controller.favourites = true
        push(of: controller, hideBar: true)
    }
}
