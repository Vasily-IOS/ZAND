//
//  AppRouter.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

class AppRouter {
    
    static let shared: DefaultRouter = AppRouter()
    
    var appDelegate: AppDelegate? {
        didSet {
            setup()
        }
    }
    
    // MARK: - Init
    
    private init() {}
    
    // MARK: -
    
    var navigationController = UINavigationController()
    var tabBarController: UITabBarController?
    private let vcFactory: DefaultVCFactory = VCFactory()
}

extension AppRouter {
    
    // MARK: - Instance methods
    
    private func setup() {
        Thread.sleep(forTimeInterval: 1.0)
        
        let vc = vcFactory.getViewController(for: .tabBar)
        tabBarController = vc as? UITabBarController
        navigationController = UINavigationController(rootViewController: vc)
        navigationController.isNavigationBarHidden = false
        navigationController.navigationBar.tintColor = .white
        appDelegate?.window?.rootViewController = navigationController
        setupNavigationbar()
        appDelegate?.window?.makeKeyAndVisible()
    }
    
    private func setupNavigationbar() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.tintColor = .white
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
                    
        navigationController.navigationBar.standardAppearance = navBarAppearance
        navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationController.navigationBar.tintColor = UIColor(red: 0, green: 0, blue: 0.2, alpha: 1)
        navigationController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension AppRouter: DefaultRouter {
    
    func push(_ type: VCType) {
        let viewController = vcFactory.getViewController(for: type)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func changeTabBarVC(to index: Int) {
        if let tabBarController = tabBarController {
            tabBarController.selectedIndex = index
        }
    }
    
    func present(type: VCType) {
        let viewController = vcFactory.getViewController(for: type)
        navigationController.present(viewController, animated: true)
    }
    
    func popViewController() {
        navigationController.popViewController(animated: true)
    }
}
