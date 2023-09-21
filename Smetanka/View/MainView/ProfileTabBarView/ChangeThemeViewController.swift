//
//  ChangeThemeViewController.swift
//  Smetanka
//
//  Created by Димон on 3.09.23.
//

import UIKit

final class ChangeThemeViewController: UIViewController {
    
    private var viewModel: ChangeThemeViewModelProtocol!
    
    private let headerLabel = UILabel()
    
    private var defaultThemeButton = AppButton()
    private var darkThemeButton = AppButton()
    private var lightThemeButton = AppButton()
    
    private var currentTheme = ThemeManager.currentStyle {
        didSet {
            selection()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ChangeThemeViewModel()
        
        view.backgroundColor = .sheetBackground
        
        configureLayout()
        
        configureActions()
        
        selection()
        
        prepareDefaultThemeButton()
        prepareDarkThemeButton()
        prepareLightThemeButton()
    }
}

private extension ChangeThemeViewController {
    
    func configureLayout() {
        configureDefaultThemeButton()
        configureDarkThemeButton()
        configureLightThemeButton()
    }
    
    func configureDefaultThemeButton() {
        defaultThemeButton = configureGeneralThemeButton(title: localized(of: .defaultThemeButton),
                                                         tag: 1)
    }
    
    func configureDarkThemeButton() {
        darkThemeButton = configureGeneralThemeButton(title: localized(of: .darkThemeButton),
                                                      tag: 2)
    }
    
    func configureLightThemeButton() {
        lightThemeButton = configureGeneralThemeButton(title: localized(of: .lightThemeButton),
                                                       tag: 3)
    }
    
    func configureGeneralThemeButton(title: String, tag: Int) -> AppButton {
        var configuration = UIButton.Configuration.plain()
        
        configuration.imagePlacement = .trailing
        
        let button = AppButton(configuration: configuration)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setImage(.radioSelected.withTintColor(.green,
                                                     renderingMode: .alwaysOriginal), for: [])
        
        button.setTitleColor(.generalText, for: .normal)
        button.titleLabel?.font = .helveticaNeueFont(18)
        button.contentHorizontalAlignment = .fill
        button.setTitle(title, for: .normal)
        button.contentMode = .scaleAspectFit
        button.layer.cornerRadius = 16
        button.tag = tag
        
        return button
    }
    
    func prepareDefaultThemeButton() {
        view.addSubview(defaultThemeButton)
        
        NSLayoutConstraint.activate([
            defaultThemeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            defaultThemeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            defaultThemeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            defaultThemeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func prepareDarkThemeButton() {
        view.addSubview(darkThemeButton)
        
        NSLayoutConstraint.activate([
            darkThemeButton.topAnchor.constraint(equalTo: defaultThemeButton.bottomAnchor, constant: 10),
            darkThemeButton.leadingAnchor.constraint(equalTo: defaultThemeButton.leadingAnchor),
            darkThemeButton.trailingAnchor.constraint(equalTo: defaultThemeButton.trailingAnchor),
            darkThemeButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func prepareLightThemeButton() {
        view.addSubview(lightThemeButton)
        
        NSLayoutConstraint.activate([
            lightThemeButton.topAnchor.constraint(equalTo: darkThemeButton.bottomAnchor, constant: 10),
            lightThemeButton.leadingAnchor.constraint(equalTo: darkThemeButton.leadingAnchor),
            lightThemeButton.trailingAnchor.constraint(equalTo: darkThemeButton.trailingAnchor),
            lightThemeButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

private extension ChangeThemeViewController {
    
    func configureActions() {
        defaultThemeButton.addTarget(self, action: #selector(changeThemeAction), for: .touchUpInside)
        darkThemeButton.addTarget(self, action: #selector(changeThemeAction), for: .touchUpInside)
        lightThemeButton.addTarget(self, action: #selector(changeThemeAction), for: .touchUpInside)
    }
    
    @objc func changeThemeAction(_ sender: AppButton) {
        switch sender.tag {
            case 1: setTheme(.unspecified)
            case 2: setTheme(.dark)
            case 3: setTheme(.light)
            default: print("No Action")
        }
    }
    
    func setTheme(_ style: UIUserInterfaceStyle) {
        currentTheme = style
        ThemeManager.switchTheme(style)
        viewModel.saveTheme(style.rawValue)
    }
}

private extension ChangeThemeViewController {
    
    func selection() {
        switch currentTheme {
            case .unspecified: selectDefault()
            case .dark: selectDark()
            case .light: selectLight()
            @unknown default: print("Unknown")
        }
    }
    
    func selectDefault() {
        defaultThemeButton.configurationUpdateHandler = { button in
            button.configuration?.image = .radioSelected
        }
        defaultThemeButton.setNeedsUpdateConfiguration()
        
        darkThemeButton.configurationUpdateHandler = { button in
            button.configuration?.image = .radioUnselected
        }
        darkThemeButton.setNeedsUpdateConfiguration()
        
        lightThemeButton.configurationUpdateHandler = { button in
            button.configuration?.image = .radioUnselected
        }
        lightThemeButton.setNeedsUpdateConfiguration()
    }
    
    func selectDark() {
        defaultThemeButton.configurationUpdateHandler = { button in
            button.configuration?.image = .radioUnselected
        }
        defaultThemeButton.setNeedsUpdateConfiguration()
        
        darkThemeButton.configurationUpdateHandler = { button in
            button.configuration?.image = .radioSelected
        }
        darkThemeButton.setNeedsUpdateConfiguration()
        
        lightThemeButton.configurationUpdateHandler = { button in
            button.configuration?.image = .radioUnselected
        }
        lightThemeButton.setNeedsUpdateConfiguration()
    }
    
    func selectLight() {
        defaultThemeButton.configurationUpdateHandler = { button in
            button.configuration?.image = .radioUnselected
        }
        defaultThemeButton.setNeedsUpdateConfiguration()
        
        darkThemeButton.configurationUpdateHandler = { button in
            button.configuration?.image = .radioUnselected
        }
        darkThemeButton.setNeedsUpdateConfiguration()
        
        lightThemeButton.configurationUpdateHandler = { button in
            button.configuration?.image = .radioSelected
        }
        lightThemeButton.setNeedsUpdateConfiguration()
    }
}
