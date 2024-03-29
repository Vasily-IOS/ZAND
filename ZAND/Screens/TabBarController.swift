//
//  TabBarController.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

final class TabBarController: UITabBarController {

    // MARK: - Properties

    var switchedViewController: UIViewController {
        var vc = UIViewController()
        let tabBarItem = UITabBarItem(
            title: AssetString.profile.rawValue,
            image: AssetImage.profile_icon.image,
            selectedImage: nil
        )

        if TokenManager.shared.bearerToken != nil {
            vc = vcFactory.getViewController(for: .profile)
            vc.tabBarItem = tabBarItem
            return vc
        } else {
            vc = vcFactory.getViewController(for: .signIn)
            vc.tabBarItem = tabBarItem
            return vc
        }
    }

    private let vcFactory: ViewControllerFactory = ViewControllerFactoryImpl()

    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        
        setViews()
        setBackButton()
    }
}

extension TabBarController {
    
    // MARK: - Instance methods
    
    private func setViews() {
        let vcFactory: ViewControllerFactory = ViewControllerFactoryImpl()
        let mainVC = vcFactory.getViewController(for: .main)
        mainVC.tabBarItem = UITabBarItem(
            title: AssetString.main.rawValue,
            image: AssetImage.main_icon.image,
            selectedImage: nil
        )

        let mapVC = vcFactory.getViewController(for: .map)
        mapVC.tabBarItem = UITabBarItem(
            title: AssetString.map.rawValue,
            image:  AssetImage.map_icon.image,
            selectedImage: nil
        )

        UITabBar.appearance().tintColor = .mainGreen
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().itemPositioning = .automatic
    
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 2.5
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        viewControllers = [mainVC, mapVC, switchedViewController]
    }
    
    private func setBackButton() {
        let backBarButtonItem = UIBarButtonItem(
            title: nil,
            style: .plain,
            target: nil,
            action: nil
        )
        navigationItem.backBarButtonItem = backBarButtonItem
    }
}
