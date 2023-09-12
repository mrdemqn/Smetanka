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
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FavouriteViewModel()
        
        bindViewModel()
        
        setupNavigationBar()
        
        configureLayout()
        
        Task {
            await viewModel.fetchRecipes()
        }
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
    }
    
    func prepareLayout() {
        prepareTableView()
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
    
    func prepareTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        push(of: controller, hideBar: true)
    }
}
