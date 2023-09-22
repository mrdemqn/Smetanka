//
//  ConfirmEmailViewController.swift
//  Smetanka
//
//  Created by Димон on 20.09.23.
//

import UIKit
import FirebaseAuth

final class ConfirmEmailViewController: UIViewController {
    
    private let headerLabel = UILabel()
    private let subHeaderLabel = UILabel()
    
    private let loadingIndicator = UIActivityIndicatorView()
    
    private let queue = DispatchQueue(label: MultiThreading.timerQueueLabel, attributes: .concurrent)
    private var timer: DispatchSourceTimer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timer = DispatchSource.makeTimerSource(queue: queue)
        configureLayout()
        prepareLayout()
        
        timer.schedule(deadline: .now(), repeating: .seconds(5))
        
        timer.setEventHandler {
            guard let user = Auth.auth().currentUser else { return }
            if user.isEmailVerified {
                self.timer.cancel()
            } else {
                user.reload { error in
                    print(error?.asAFError)
                }
            }
        }
        
        timer.setCancelHandler {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                let controller = self.getViewController(MainTabBarViewController.self,
                                                        Navigation.mainTabBar)
                self.setViewControllers(of: controller, animated: true)
            }
        }
        
        timer.resume()
    }
    
    deinit {
        timer.cancel()
    }
}

private extension ConfirmEmailViewController {
    
    func configureLayout() {
        configureSuperView()
        configureLabels()
        configureActivityIndicator()
    }
    
    func prepareLayout() {
        prepareLabels()
        prepareActivityIndicator()
    }
    
    func configureSuperView() {
        view.backgroundColor = .background
    }
    
    func configureLabels() {
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        subHeaderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        headerLabel.text = localized(of: .unverifiedEmailTitle)
        subHeaderLabel.text = localized(of: .unverifiedEmailMessage)
        
        headerLabel.font = .helveticaNeueFont(28, weight: .heavy)
        subHeaderLabel.font = .helveticaNeueFont(20, weight: .medium)
        
        headerLabel.numberOfLines = 0
        subHeaderLabel.numberOfLines = 0
        
        headerLabel.textAlignment = .center
        subHeaderLabel.textAlignment = .center
    }
    
    func configureActivityIndicator() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.large
        loadingIndicator.startAnimating()
    }
    
    func prepareLabels() {
        view.addSubview(headerLabel)
        view.addSubview(subHeaderLabel)
        
        NSLayoutConstraint.activate([
            /// MARK - Header Label
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
            
            /// MARK - SubHeader Label
            subHeaderLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
            subHeaderLabel.leadingAnchor.constraint(equalTo: headerLabel.leadingAnchor),
            subHeaderLabel.trailingAnchor.constraint(equalTo: headerLabel.trailingAnchor),
        ])
    }
    
    func prepareActivityIndicator() {
        view.addSubview(loadingIndicator)
        
        NSLayoutConstraint.activate([
            loadingIndicator.bottomAnchor.constraint(equalTo: headerLabel.topAnchor, constant: -20),
            loadingIndicator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25),
            loadingIndicator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -25),
        ])
    }
}
