//
//  UIViewControllerExtensions.swift
//  Smetanka
//
//  Created by Димон on 2.08.23.
//

import UIKit

extension UIViewController {
    
    /// MARK: - Необходимо, чтобы название Storyboard и Identifier ViewController'a были одинаковыми
    func getViewController<T>(_ type: T.Type,
                              _ identifier: String) -> T where T: UIViewController {
        let storyboard = UIStoryboard(name: String(describing: identifier), bundle: nil)
        
        guard let controller = storyboard
            .instantiateViewController(withIdentifier: String(describing: identifier)) as? T else {
            fatalError("ViewController is not type of \(String(describing: self))")
        }
        
        return controller
    }
    
    /// MARK: - Для случаев, когда необходимо сделать
    /// идентификатор storyboard и название файла storyboard с разными названиями
    func getViewController<T>(_ type: T.Type,
                              _ storyboardFileName: String,
                              _ storyboardIdentifier: String) -> T where T: UIViewController {
        let storyboard = UIStoryboard(name: String(describing: storyboardFileName), bundle: nil)
        
        guard let controller = storyboard
            .instantiateViewController(withIdentifier: String(describing: storyboardIdentifier)) as? T else {
            fatalError("ViewController is not type of \(String(describing: self))")
        }
        
        return controller
    }
    
    /// MARK: - Необходимо, чтобы название Storyboard и Identifier ViewController'a были одинаковыми
    func setViewController(_ identifier: String,
                           animated: Bool = false) {
        let controller = getViewController(UIViewController.self,
                                           identifier)
        
        setViewController(controller, animated: animated)
    }
    
    /// MARK: - Для случаев, когда необходимо сделать
    /// идентификатор storyboard и название файла storyboard с разными названиями
    func setViewController(_ storyboardFileName: String,
                           _ storyboardIdentifier: String,
                           animated: Bool = false) {
        let controller = getViewController(UIViewController.self,
                                           storyboardFileName,
                                           storyboardIdentifier)
        
        setViewController(controller, animated: animated)
    }
    
    /// MARK: - Необходимо, чтобы название Storyboard и Identifier ViewController'a были одинаковыми
    func push(to identifier: String) {
        let storyboard = UIStoryboard(name: String(describing: identifier), bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: String(describing: identifier))
        
        push(of: controller)
    }
    
    func push(of viewController: UIViewController, animated: Bool = true) {
        navigationController?.pushViewController(viewController, animated: animated)
    }
    
    func pop(_ animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }
    
    func popToRootViewController(animated: Bool = true) {
        navigationController?.popToRootViewController(animated: animated)
    }
    
    func present(to controller: UIViewController, animated: Bool = true) {
        present(controller, animated: animated)
    }
    
    private func setViewController(_ viewController: UIViewController, animated: Bool = false) {
        navigationController?.setViewControllers([viewController], animated: animated)
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(title: localized(of: .errorAlertTitle), message: localized(of: .somethingWrong), preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: localized(of: .errorAlertCancelActionTitle), style: .destructive)
        
        alert.addAction(cancelAction)
        
        present(to: alert)
    }
}