//
//  ChangeThemeViewController.swift
//  Smetanka
//
//  Created by Димон on 3.09.23.
//

import UIKit

class ChangeThemeViewController: UIViewController {
    
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
        view.backgroundColor = .sheetBackground
        
        configureLayout()
        
        configureActions()
        
        selection()
        
        prepareDefaultThemeButton()
        prepareDarkThemeButton()
        prepareLightThemeButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        prepareDidAppear()
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
        var container = AttributeContainer()
        container.font = .helveticaNeueFont(18)
        container.foregroundColor = .generalText
        
        configuration.attributedTitle = AttributedString(title, attributes: container)
        
        configuration.titleAlignment = .leading
        
        configuration.image = .radioSelected
        configuration.imagePlacement = .trailing
        configuration.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(pointSize: 30)
        configuration.imagePadding = 10
        
        let button = AppButton(configuration: configuration)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
//        button.contentHorizontalAlignment = .fill
//        button.contentMode = .scaleAspectFit
//        button.layer.cornerRadius = 20
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
    
    func prepareDidAppear() {
        
    }
}

private extension ChangeThemeViewController {
    
    func configureActions() {
        defaultThemeButton.addTarget(self, action: #selector(changeThemeAction), for: .touchUpInside)
        darkThemeButton.addTarget(self, action: #selector(changeThemeAction), for: .touchUpInside)
        lightThemeButton.addTarget(self, action: #selector(changeThemeAction), for: .touchUpInside)
    }
    
    @objc func changeThemeAction(_ sender: AppButton) {
        print("Hello Sender: \(sender.tag)")
        switch sender.tag {
            case 1: setDefaultTheme()
            case 2: setDarkTheme()
            case 3: setLightTheme()
            default: print("No Action")
        }
    }
    
    func setDefaultTheme() {
        print("Case One")
    }
    
    func setDarkTheme() {
        print("Case Two")
    }
    
    func setLightTheme() {
        print("Case Three")
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
        defaultThemeButton.configuration?.image = .radioSelected
        darkThemeButton.configuration?.image = .radioUnselected
        lightThemeButton.configuration?.image = .radioUnselected
        defaultThemeButton.setNeedsUpdateConfiguration()
//        defaultThemeButton.setImage(.radioSelected, for: [.normal, .highlighted])
//        darkThemeButton.setImage(.radioUnselected, for: [.normal, .highlighted])
//        lightThemeButton.setImage(.radioUnselected, for: [.normal, .highlighted])
    }
    
    func selectDark() {
        defaultThemeButton.configuration?.image = .radioUnselected
        darkThemeButton.configuration?.image = .radioSelected
        lightThemeButton.configuration?.image = .radioUnselected
        defaultThemeButton.setNeedsUpdateConfiguration()
//        defaultThemeButton.setImage(.radioUnselected, for: [.normal, .highlighted])
//        darkThemeButton.setImage(.radioSelected, for: [.normal, .highlighted])
//        lightThemeButton.setImage(.radioUnselected, for: [.normal, .highlighted])
    }
    
    func selectLight() {
        defaultThemeButton.configuration?.image = .radioUnselected
        darkThemeButton.configuration?.image = .radioUnselected
        lightThemeButton.configuration?.image = .radioSelected
        defaultThemeButton.setNeedsUpdateConfiguration()
//        defaultThemeButton.setImage(.radioUnselected, for: [.normal, .highlighted])
//        darkThemeButton.setImage(.radioUnselected, for: [.normal, .highlighted])
//        lightThemeButton.setImage(.radioSelected, for: [.normal, .highlighted])
    }
}
