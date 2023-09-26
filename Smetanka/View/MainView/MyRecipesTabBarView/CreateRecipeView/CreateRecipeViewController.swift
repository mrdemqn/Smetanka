//
//  CreateRecipeViewController.swift
//  Smetanka
//
//  Created by Димон on 21.09.23.
//

import UIKit
import Hero

final class CreateRecipeViewController: UIViewController {
    
    private var textViewStepsList: [UITextView] = []
    private var stepNumberLabelsList: [UILabel] = []
    
    private var stepsCount = 1
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let addStepButton = UIImageView()
    
    private let imageView = UIImageView()
    
    private let titleLabel = UILabel()
    private let difficultyLabel = UILabel()
    private let portionLabel = UILabel()
    private let timeLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let stepsLabel = UILabel()
    
    private let titleTextField = AppField()
    private let difficultyTextField = AppField()
    private let portionTextField = AppField()
    private let timeTextField = AppField()
    private let descriptionTextField = AppField()
    private let stepTextField = AppField()
    
    private let stepTextView = UITextView()
    
    private var bottomViewAnchor: NSLayoutConstraint!
    
    private var textView: UITextView {
        createStep()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isHeroEnabled = true
        textViewStepsList.append(textView)
        textViewStepsList.append(textView)
        textViewStepsList.append(textView)
        stepNumberLabelsList.append(createStepNumber(index: 0))
        stepNumberLabelsList.append(createStepNumber(index: 1))
        stepNumberLabelsList.append(createStepNumber(index: 2))
        configureLayout()
        prepareLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = localized(of: .recipe)
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(saveRecipe))
    }
}

private extension CreateRecipeViewController {
    
    func configureLayout() {
        configureSuperView()
        configureScrollView()
        configureContentView()
        configureImageView()
        configureLabels()
        configureTextFields()
        configureAddStepButton()
    }
    
    func prepareLayout() {
        prepareScrollView()
        prepareImageView()
        prepareLabelsAndTextFields()
        prepareStepsTextView()
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
    
    func configureImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .black.withAlphaComponent(0.1)
        let image = UIImage(systemName: "camera.on.rectangle")
        imageView.frame = CGRect(x: 0, y: 0, width: 0, height: 200)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
    }
    
    func configureLabels() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        difficultyLabel.translatesAutoresizingMaskIntoConstraints = false
        portionLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        stepsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.text = localized(of: .titleRecipePlaceholder)
        difficultyLabel.text = localized(of: .difficultyRecipePlaceholder)
        portionLabel.text = localized(of: .portionRecipePlaceholder)
        timeLabel.text = localized(of: .timeRecipePlaceholder)
        descriptionLabel.text = localized(of: .descriptionRecipePlaceholder)
        stepsLabel.text = localized(of: .stepsTitle)
        
        titleLabel.font = .helveticaNeueFont(18, weight: .bold)
        difficultyLabel.font = .helveticaNeueFont(18, weight: .bold)
        portionLabel.font = .helveticaNeueFont(18, weight: .bold)
        timeLabel.font = .helveticaNeueFont(18, weight: .bold)
        descriptionLabel.font = .helveticaNeueFont(18, weight: .bold)
        stepsLabel.font = .helveticaNeueFont(18, weight: .bold)
        
    }
    
    func configureTextFields() {
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        difficultyTextField.translatesAutoresizingMaskIntoConstraints = false
        portionTextField.translatesAutoresizingMaskIntoConstraints = false
        timeTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        stepTextField.translatesAutoresizingMaskIntoConstraints = false
        
        titleTextField.setupPlaceholder(localized(of: .titleRecipePlaceholder))
        difficultyTextField.setupPlaceholder(localized(of: .difficultyRecipePlaceholder))
        portionTextField.setupPlaceholder(localized(of: .portionRecipePlaceholder))
        timeTextField.setupPlaceholder(localized(of: .timeRecipePlaceholder))
        descriptionTextField.setupPlaceholder(localized(of: .descriptionRecipePlaceholder))
        stepTextField.setupPlaceholder(localized(of: .stepRecipePlaceholder))
        
        titleTextField.font = .helveticaNeueFont(18, weight: .black)
        difficultyTextField.font = .helveticaNeueFont(18, weight: .black)
        portionTextField.font = .helveticaNeueFont(18, weight: .black)
        timeTextField.font = .helveticaNeueFont(18, weight: .black)
        descriptionTextField.font = .helveticaNeueFont(18, weight: .black)
        stepTextField.font = .helveticaNeueFont(18, weight: .black)
    }
    
    func configureAddStepButton() {
        addStepButton.translatesAutoresizingMaskIntoConstraints = false
        addStepButton.image = .add
        addStepButton.tintColor = .systemGreen
        addStepButton.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(addNewStep))
        addStepButton.addGestureRecognizer(gesture)
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
    
    func prepareImageView() {
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }
    
    func prepareLabelsAndTextFields() {
        /// MARK - Текстовые поля
        contentView.addSubview(titleTextField)
        contentView.addSubview(difficultyTextField)
        contentView.addSubview(portionTextField)
        contentView.addSubview(timeTextField)
        contentView.addSubview(descriptionTextField)
        
        /// MARK - Лейблы для текстовых полей
        contentView.addSubview(titleLabel)
        contentView.addSubview(difficultyLabel)
        contentView.addSubview(portionLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(stepsLabel)
        
        bottomViewAnchor = stepsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        NSLayoutConstraint.activate([
            /// MARK - Title
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25),
            
            /// MARK - Title TextField
            titleTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            titleTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            titleTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            /// MARK - Difficulty
            difficultyLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 30),
            difficultyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            difficultyLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            /// MARK - Difficulty TextField
            difficultyTextField.topAnchor.constraint(equalTo: difficultyLabel.bottomAnchor, constant: 10),
            difficultyTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            difficultyTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            /// MARK - Portion
            portionLabel.topAnchor.constraint(equalTo: difficultyTextField.bottomAnchor, constant: 30),
            portionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            portionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            /// MARK - Portion TextField
            portionTextField.topAnchor.constraint(equalTo: portionLabel.bottomAnchor, constant: 10),
            portionTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            portionTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            /// MARK - Time
            timeLabel.topAnchor.constraint(equalTo: portionTextField.bottomAnchor, constant: 30),
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            /// MARK - Time TextField
            timeTextField.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 10),
            timeTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            timeTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            /// MARK - Description
            descriptionLabel.topAnchor.constraint(equalTo: timeTextField.bottomAnchor, constant: 30),
            descriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            /// MARK - Description TextField
            descriptionTextField.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            descriptionTextField.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descriptionTextField.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            /// MARK - Steps
            stepsLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 30),
            stepsLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            stepsLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
        ])
    }
    
    func prepareStepsTextView() {
        for (index, textView) in textViewStepsList.enumerated() {
            let isLast = textViewStepsList.count == (index + 1)
            let isFirst = index == 0
            let previousStepView = isFirst ? stepsLabel : textViewStepsList[index - 1]
            let numberLabel = stepNumberLabelsList[index]
            prepareStep(previousStepView: previousStepView,
                        stepView: textView,
                        numberLabel: numberLabel,
                        isLast: isLast)
        }
    }
    
    func reloadStepViews() {
        for (index, textView) in textViewStepsList.enumerated() {
            stepNumberLabelsList[index].removeFromSuperview()
            textView.removeFromSuperview()
        }
        addStepButton.removeFromSuperview()
        
        textViewStepsList.append(textView)
        stepNumberLabelsList.append(createStepNumber(index: stepNumberLabelsList.count))
        
        prepareStepsTextView()
    }
}

private extension CreateRecipeViewController {
    
    func createStep() -> UITextView {
        let textView = UITextView()
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .helveticaNeueFont(16, weight: .medium)
        textView.isEditable = true
        textView.textColor = .fieldText
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.borderWidth = 0.3
        textView.layer.cornerRadius = 20
        textView.layer.shadowColor = UIColor.gray.cgColor
        textView.layer.shadowRadius = 10
        textView.layer.shadowOpacity = 0.3
        textView.layer.shadowOffset = CGSize(width: 10, height: 10)
        textView.backgroundColor = .background
        textView.textContainer.maximumNumberOfLines = 0
        textView.contentInset = .init(top: 10, left: 10, bottom: 10, right: 10)
        
        return textView
    }
    
    func createStepNumber(index: Int) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "\(index + 1):"
        
        label.font = .helveticaNeueFont(18, weight: .bold)
        
        return label
    }
    
    func prepareStep(previousStepView: UIView,
                     stepView: UITextView,
                     numberLabel: UILabel,
                     isLast: Bool) {
        if isLast {
            isLastStep(previousStepView: previousStepView,
                       stepView: stepView,
                       numberLabel: numberLabel)
        } else {
            isNotLastStep(previousStepView: previousStepView,
                          stepView: stepView,
                          numberLabel: numberLabel)
        }
    }
    
    func isNotLastStep(previousStepView: UIView,
                       stepView: UITextView,
                       numberLabel: UILabel) {
        contentView.addSubview(stepView)
        contentView.addSubview(numberLabel)
        
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: stepView.topAnchor, constant: 10),
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            numberLabel.trailingAnchor.constraint(equalTo: stepView.leadingAnchor, constant: -10),
            
            stepView.topAnchor.constraint(equalTo: previousStepView.bottomAnchor, constant: 30),
            stepView.trailingAnchor.constraint(equalTo: previousStepView.trailingAnchor),
            stepView.heightAnchor.constraint(equalToConstant: 100),
        ])
    }
    
    func isLastStep(previousStepView: UIView,
                    stepView: UITextView,
                    numberLabel: UILabel) {
        contentView.addSubview(numberLabel)
        contentView.addSubview(stepView)
        contentView.addSubview(addStepButton)
        
        NSLayoutConstraint.activate([
            numberLabel.topAnchor.constraint(equalTo: stepView.topAnchor, constant: 10),
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25),
            numberLabel.trailingAnchor.constraint(equalTo: stepView.leadingAnchor, constant: -10),
            
            stepView.topAnchor.constraint(equalTo: previousStepView.bottomAnchor, constant: 30),
            stepView.heightAnchor.constraint(equalToConstant: 100),
            stepView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            addStepButton.topAnchor.constraint(equalTo: stepView.topAnchor, constant: 10),
            addStepButton.leadingAnchor.constraint(equalTo: stepView.trailingAnchor, constant: 10),
            addStepButton.trailingAnchor.constraint(equalTo: previousStepView.trailingAnchor),
            addStepButton.heightAnchor.constraint(equalToConstant: 30),
            addStepButton.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
}

private extension CreateRecipeViewController {
    
    @objc func addNewStep() {
        reloadStepViews()
    }
    
    @objc func saveRecipe() {
        
    }
}
