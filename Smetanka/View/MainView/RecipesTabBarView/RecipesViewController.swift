//
//  RecipesViewController.swift
//  Smetanka
//
//  Created by Димон on 9.08.23.
//

import UIKit
import RxSwift
import Alamofire
import RealmSwift

final class RecipesViewController: UIViewController {
    
    private var viewModel: RecipesViewModelProtocol!
    
    @IBOutlet var tableView: UITableView!
    
    private let recipesNotFoundLabel = UILabel()
    
    private lazy var loadingView: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        
        view.hidesWhenStopped = true
        view.style = UIActivityIndicatorView.Style.large
        view.startAnimating()
        return view
    }()
    
    private let vertical: CGFloat = 8
    private let horizontal: CGFloat = 25
    
    private let disposeBag = DisposeBag()
    
    private lazy var tabBarTitles: [String] = {
        return [localized(of: .recipes),
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
        
        configureRecipesNotFoundLabel()
        prepareRecipesNotFoundLabel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        recipesNotFoundLabel.isHidden = !viewModel.recipes.isEmpty
    }
}

extension RecipesViewController {
    
    private func setupNavigationBar() {
        navigationItem.title = localized(of: .recipes)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func configureRecipesNotFoundLabel() {
        recipesNotFoundLabel.translatesAutoresizingMaskIntoConstraints = false
        recipesNotFoundLabel.text = localized(of: .favouritesNotFound)
        recipesNotFoundLabel.font = .helveticaNeueFont(20, weight: .bold)
        recipesNotFoundLabel.numberOfLines = 0
        recipesNotFoundLabel.textAlignment = .center
        recipesNotFoundLabel.isHidden = !viewModel.recipes.isEmpty
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
        tableView.register(nib, forCellReuseIdentifier: Xibs.recipeCell)
        
        tableView.separatorStyle = .none
    }
    
    private func showLoadingView() {
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func bindViewModel() {
        viewModel.loadingSubject.subscribe { isLoading in
            DispatchQueue.main.async { [unowned self] in
                if isLoading {
                    showLoadingView()
                } else {
                    loadingView.stopAnimating()
                }
            }
        }.disposed(by: disposeBag)
        
        viewModel.recipesSubject.subscribe { _ in
            DispatchQueue.main.async { [unowned self] in
                tableView.reloadData()
                recipesNotFoundLabel.isHidden = !viewModel.recipes.isEmpty
            }
        }.disposed(by: disposeBag)
        
        viewModel.failureSubject.subscribe { [unowned self] _ in
            showErrorAlert()
        }.disposed(by: disposeBag)
    }
}

extension RecipesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Xibs.recipeCell, for: indexPath)
        return cell
    }
}

extension RecipesViewController: UITableViewDelegate {
    
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
