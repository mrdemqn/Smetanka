//
//  OnboardingViewController.swift
//  Smetanka
//
//  Created by Димон on 2.08.23.
//

import UIKit

final class OnboardingViewController: UIPageViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        dataSource = self
        
        guard let controller = controllers.first else { return }
        
        setViewControllers([controller],
                           direction: .forward,
                           animated: true)
    }
    
    private lazy var controllers: [UIViewController] = {
        return [
            getViewController(FirstPageViewController.self,
                              Navigation.firstPage),
            getViewController(SecondPageViewController.self,
                              Navigation.secondPage)
        ]
    }()
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = controllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else { return nil /*controllers.last*/ }
        
        guard controllers.count > previousIndex else { return nil }
        
        return controllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = controllers.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let controllersCount = controllers.count
        
        guard controllersCount != nextIndex else { return nil /* controllers.first */ }
        
        guard controllersCount > nextIndex else { return nil }
        
        return controllers[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    
}

extension OnboardingViewController {
    
    func scrollToNextPage() {
        print(#function)
        setViewControllers([controllers[1]],
                           direction: .forward,
                           animated: true)
    }
    
    func skipOnboarding() {
        print(#function)
    }
}
