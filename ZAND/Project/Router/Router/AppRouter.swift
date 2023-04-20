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
        navigationController.isNavigationBarHidden = true
        appDelegate?.window?.rootViewController = navigationController
        appDelegate?.window?.makeKeyAndVisible()
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
}
