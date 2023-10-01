//
//  DetailsRecipeViewController.swift
//  Smetanka
//
//  Created by Димон on 10.08.23.
//

import UIKit
import RxSwift
import Hero

final class DetailsRecipeViewController: UIViewController {
    
    private var viewModel: DetailsRecipeViewModelProtocol!
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private var loadingActivityIndicator = UIActivityIndicatorView()
    
    private var programRecipeImageView = UIImageView()
    
    private var programRecipeTitleLabel = UILabel()
    private var programRecipeDifficultyLabel = UILabel()
    private var programRecipePortionLabel = UILabel()
    private var programRecipeTimeLabel = UILabel()
    private var programRecipeDescriptionTitleLabel = UILabel()
    private var programRecipeDescriptionLabel = UILabel()
    private var programRecipeStepsTitleLabel = UILabel()
    private var programRecipeStepsLabel = UILabel()
    
    private let disposeBag = DisposeBag()
    
    var recipeId: String?
    var favourites: Bool = false
    var fromMyRecipe: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isHeroEnabled = true
        programRecipeImageView.heroID = "ImageID"
        setupLoadingLayout()
        
        viewModel = DetailsRecipeViewModel()
        
        bindViewModel()
        
        guard let id = recipeId else { return }
        
        Task {
            if favourites {
                await viewModel.fetchLocalRecipe(id)
            } else {
                await viewModel.fetchLocalIfExists(id)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = localized(of: .recipe)
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .plain, target: self, action: #selector(changeFavourite))
    }
    
    deinit {
        viewModel.recipePublish.dispose()
        viewModel.loadingSubject.dispose()
    }
}

private extension DetailsRecipeViewController {
    
    func bindViewModel() {
        
        viewModel.loadingSubject.subscribe(
            onNext: setLoadingUI
        ).disposed(by: disposeBag)
        
        viewModel.recipePublish.subscribe(
            onNext: setRecipeUI
        ).disposed(by: disposeBag)
        
        viewModel.favouriteButtonSubject.subscribe(
            onNext: { [unowned self] isFavourite in
                changeBarButton(isFavourite: isFavourite)
            }
        ).disposed(by: disposeBag)
        
        viewModel.failureSubject.subscribe { [unowned self] _ in
            showErrorAlert()
        }.disposed(by: disposeBag)
    }
    
    func changeBarButton(isFavourite: Bool) {
        DispatchQueue.main.async {
            let image = UIImage(systemName: isFavourite ? "star.fill" : "star")
            print("Fetch Local Recipe Success 2: \(isFavourite)")
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: image,
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(self.changeFavourite))
        }
    }
    
    @objc func changeFavourite() {
        viewModel.changeFavourite()
    }
}

private extension DetailsRecipeViewController {
    
    func setupLoadingLayout() {
        configureSuperView()
        configureScrollView()
        prepareScrollView()
        configureContentView()
        configureImageView()
        configureLabels()
    }
    
    func setupLayout() {
        prepareImageView()
        prepareLabels()
    }
    
    func configureSuperView() {
        view.backgroundColor = .background
    }
    
    func configureScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = true
        scrollView.alwaysBounceVertical = true
        scrollView.backgroundColor = .background
    }
    
    func configureContentView() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .background
    }
    
    func prepareScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func configureImageView() {
        programRecipeImageView.translatesAutoresizingMaskIntoConstraints = false
        
        programRecipeImageView.contentMode = .scaleToFill
    }
    
    func prepareImageView() {
        contentView.addSubview(programRecipeImageView)
        
        NSLayoutConstraint.activate([
            programRecipeImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            programRecipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            programRecipeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            programRecipeImageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func configureLabels() {
        programRecipeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        programRecipeTitleLabel.numberOfLines = 0
        
        programRecipeDifficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        programRecipeDifficultyLabel.numberOfLines = 0
        
        programRecipePortionLabel.translatesAutoresizingMaskIntoConstraints = false
        programRecipePortionLabel.numberOfLines = 0
        
        programRecipeTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        programRecipeTimeLabel.numberOfLines = 0
        
        programRecipeDescriptionTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        programRecipeDescriptionTitleLabel.numberOfLines = 0
        
        programRecipeDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        programRecipeDescriptionLabel.numberOfLines = 0
        
        programRecipeStepsTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        programRecipeStepsTitleLabel.numberOfLines = 0
        
        programRecipeStepsLabel.translatesAutoresizingMaskIntoConstraints = false
        programRecipeStepsLabel.numberOfLines = 0
    }
    
    func prepareLabels() {
        
        contentView.addSubview(programRecipeTitleLabel)
        contentView.addSubview(programRecipeDifficultyLabel)
        contentView.addSubview(programRecipePortionLabel)
        contentView.addSubview(programRecipeTimeLabel)
        contentView.addSubview(programRecipeDescriptionTitleLabel)
        contentView.addSubview(programRecipeDescriptionLabel)
        contentView.addSubview(programRecipeStepsTitleLabel)
        contentView.addSubview(programRecipeStepsLabel)
        
        NSLayoutConstraint.activate([
            
            /// MARK - Recipe Title Label
            programRecipeTitleLabel.topAnchor.constraint(equalTo: programRecipeImageView.bottomAnchor, constant: 40),
            programRecipeTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,
                                                             constant: 15),
            programRecipeTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,
                                                              constant: -15),
            
            /// MARK - Difficulty Label
            programRecipeDifficultyLabel.topAnchor.constraint(equalTo: programRecipeTitleLabel.bottomAnchor,
                                                              constant: 20),
            programRecipeDifficultyLabel.leadingAnchor.constraint(equalTo: programRecipeTitleLabel.leadingAnchor),
            programRecipeDifficultyLabel.trailingAnchor.constraint(equalTo: programRecipeTitleLabel.trailingAnchor),
            
            /// MARK - Portion Label
            programRecipePortionLabel.topAnchor.constraint(equalTo: programRecipeDifficultyLabel.bottomAnchor,
                                                           constant: 15),
            programRecipePortionLabel.leadingAnchor.constraint(equalTo: programRecipeDifficultyLabel.leadingAnchor),
            programRecipePortionLabel.trailingAnchor.constraint(equalTo: programRecipeDifficultyLabel.trailingAnchor),
            
            /// MARK - Time Label
            programRecipeTimeLabel.topAnchor.constraint(equalTo: programRecipePortionLabel.bottomAnchor,
                                                        constant: 15),
            programRecipeTimeLabel.leadingAnchor.constraint(equalTo: programRecipePortionLabel.leadingAnchor),
            programRecipeTimeLabel.trailingAnchor.constraint(equalTo: programRecipePortionLabel.trailingAnchor),
            
            /// MARK - Description Title Label
            programRecipeDescriptionTitleLabel.topAnchor.constraint(equalTo: programRecipeTimeLabel.bottomAnchor,
                                                                    constant: 30),
            programRecipeDescriptionTitleLabel.leadingAnchor.constraint(equalTo: programRecipeTimeLabel.leadingAnchor),
            programRecipeDescriptionTitleLabel.trailingAnchor.constraint(equalTo: programRecipeTimeLabel.trailingAnchor),
            
            /// MARK - Description Label
            programRecipeDescriptionLabel.topAnchor.constraint(equalTo: programRecipeDescriptionTitleLabel.bottomAnchor,
                                                               constant: 15),
            programRecipeDescriptionLabel.leadingAnchor.constraint(equalTo: programRecipeDescriptionTitleLabel.leadingAnchor),
            programRecipeDescriptionLabel.trailingAnchor.constraint(equalTo: programRecipeDescriptionTitleLabel.trailingAnchor),
            
            /// MARK - Steps Title Label
            programRecipeStepsTitleLabel.topAnchor.constraint(equalTo: programRecipeDescriptionLabel.bottomAnchor,
                                                              constant: 30),
            programRecipeStepsTitleLabel.leadingAnchor.constraint(equalTo: programRecipeDescriptionLabel.leadingAnchor),
            programRecipeStepsTitleLabel.trailingAnchor.constraint(equalTo: programRecipeDescriptionLabel.trailingAnchor),
            
            /// MARK - Steps Label
            programRecipeStepsLabel.topAnchor.constraint(equalTo: programRecipeStepsTitleLabel.bottomAnchor,
                                                         constant: 15),
            programRecipeStepsLabel.leadingAnchor.constraint(equalTo: programRecipeStepsTitleLabel.leadingAnchor),
            programRecipeStepsLabel.trailingAnchor.constraint(equalTo: programRecipeStepsTitleLabel.trailingAnchor),
            programRecipeStepsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func setRecipeUI(_ recipe: LocalRecipe) {
        DispatchQueue.main.async { [unowned self] in
            print("Recipe: \(recipe.image)")
            if fromMyRecipe {
                guard let data = recipe.uiImage else { return }
                programRecipeImageView.image = UIImage(data: data)
            } else {
                programRecipeImageView.load(from: recipe.image)
            }
            programRecipeTitleLabel.text = recipe.title
            programRecipeDifficultyLabel.text = String(describing: localized(of: .difficulty) + ": \(recipe.difficulty)")
            programRecipePortionLabel.text = String(describing: localized(of: .portion) + ": \(recipe.portion ?? "0")")
            programRecipeTimeLabel.text = String(describing: localized(of: .time) + ": \(recipe.time ?? "0"))")
            programRecipeDescriptionTitleLabel.text = localized(of: .descriptionTitle) + ":"
            programRecipeDescriptionLabel.text = recipe.description ?? "-"
            programRecipeStepsTitleLabel.text = localized(of: .stepsTitle) + ":"
            programRecipeStepsLabel.text = configureStepsLabel(recipe.foodMethods)
        }
    }
    
    func configureStepsLabel(_ steps: [String]) -> String {
        var text = ""
        
        for (index, step) in steps.enumerated() {
            let stepNumber = "\(index + 1): "
            text += stepNumber + step + "\n\n"
        }
        
        return text
    }
    
    func setLoadingUI(_ isLoading: Bool) {
        DispatchQueue.main.async { [unowned self] in
            if isLoading {
                loadingActivityIndicator.translatesAutoresizingMaskIntoConstraints = false
                
                contentView.addSubview(loadingActivityIndicator)
                
                NSLayoutConstraint.activate([
                    loadingActivityIndicator.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor, constant: 200),
                    loadingActivityIndicator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
                    loadingActivityIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
                    loadingActivityIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
                ])
                
                loadingActivityIndicator.startAnimating()
            } else {
                loadingActivityIndicator.stopAnimating()
                loadingActivityIndicator.removeFromSuperview()
                setupLayout()
            }
        }
    }
}
