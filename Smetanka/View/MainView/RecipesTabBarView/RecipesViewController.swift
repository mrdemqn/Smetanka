//
//  RecipesViewController.swift
//  Smetanka
//
//  Created by Димон on 9.08.23.
//

import UIKit
import RxSwift

final class RecipesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private var viewModel: RecipesViewModelProtocol!
    
    private let vertical: CGFloat = 8
    private let horizontal: CGFloat = 25
    
    private let disposeBag = DisposeBag()
    
    private lazy var tabBarTitles: [String] = {
        return [localized(of: .recipesTabBarTitle),
                localized(of: .favouritesTabBarTitle),
                localized(of: .myRecipesTabBarTitle),
                localized(of: .profileTabBarTitle)]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = RecipesViewModel()
        
        bindViewModel()
        
        setupTabBar()
        setupTableView()
        
        Task {
            await viewModel.fetchRecipes()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

extension RecipesViewController {
    
    private func setupNavigationBar() {
        navigationItem.title = "Рецепты"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTabBar() {
        guard let items = tabBarController?.tabBar.items else { return }
        
        for (index, item) in items.enumerated() {
            let title = tabBarTitles[index]
            item.title = title
            let font = UIFont.boldSystemFont(ofSize: 11)
            
            item.setTitleTextAttributes([.font: font], for: .normal)
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        
        let nib = UINib(nibName: "\(RecipeTableViewCell.self)", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "RecipeCell")
        
        tableView.separatorStyle = .none
    }
    
    private func bindViewModel() {
        viewModel.loadingSubject.subscribe { isLoading in
            
        }.disposed(by: disposeBag)
        
        viewModel.recipesSubject.subscribe { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }.disposed(by: disposeBag)
    }
}

extension RecipesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? RecipeTableViewCell else { return UITableViewCell() }
        
        let recipe = viewModel.recipes[indexPath.item]
        
        cell.configure(title: recipe.title,
                       difficulty: recipe.difficulty,
                       imageUrl: recipe.image)
        return cell
    }
}

extension RecipesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        push(to: Navigation.detailsRecipe)
    }
}
