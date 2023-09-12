//
//  RecipesViewController.swift
//  Smetanka
//
//  Created by Димон on 9.08.23.
//

import UIKit
import RxSwift
import Alamofire

final class RecipesViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private var viewModel: RecipesViewModelProtocol!
    
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
//            await viewModel.fetchRecipes()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
}

extension RecipesViewController {
    
    private func setupNavigationBar() {
        navigationItem.title = localized(of: .recipes)
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
        tableView.register(nib, forCellReuseIdentifier: Xibs.recipeCell)
        
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
    
    private func translate() async {
        let session: Session = {
            let configuration = URLSessionConfiguration.af.default
            configuration.requestCachePolicy = .returnCacheDataElseLoad
            
            let interceptor = TranslateInterceptor()
            
            return Session(configuration: configuration,
                           interceptor: interceptor)
        }()
        
        let _ = await session
            .request("https://api.modernmt.com/translate",
                     parameters: ["source": "en",
                                  "target": "ru",
                                  "q": "Hello"])
            .serializingDecodable(Translation.self)
            .response
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

final class TranslateInterceptor: RequestInterceptor {
    
    private let retryLimit: Int = 5
    private let retryDelay: TimeInterval = 10
    
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var urlRequest = urlRequest
        urlRequest.setValue("EB81AD9F-3184-CFE4-5033-D3FCE339B411", forHTTPHeaderField: "MMT-ApiKey")
        
        completion(.success(urlRequest))
    }
    
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        let response = request.task?.response as? HTTPURLResponse
        
        guard let statusCode = response?.statusCode, (500...599).contains(statusCode) else {
            return completion(.doNotRetry)
        }
        
        completion(.retryWithDelay(retryDelay))
    }
}

struct Translation: Decodable {
    let status: Int
    let data: TranslationData
    
    struct TranslationData: Decodable {
        let translation: String
    }
}
