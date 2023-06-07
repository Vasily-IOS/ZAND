//
//  TabBarController.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
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
        let vcFactory: DefaultVCFactory = VCFactory()
        let mainVC = vcFactory.getViewController(for: .main)
        mainVC.tabBarItem = UITabBarItem(title: StringsAsset.main,
                                         image: ImageAsset.main_icon,
                                         selectedImage: nil)

        
        let mapVC = vcFactory.getViewController(for: .map)
        mapVC.tabBarItem = UITabBarItem(title: StringsAsset.map,
                                        image:  ImageAsset.map_icon,
                                        selectedImage: nil)
        
        let signInView = SignInView()
        let signInVc = SignInViewController(contentView: signInView)
        signInVc.tabBarItem = UITabBarItem(title: StringsAsset.profile,
                                           image: ImageAsset.profile_icon,
                                           selectedImage: nil)

        UITabBar.appearance().tintColor = .mainGreen
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().itemPositioning = .automatic
    
        tabBar.layer.shadowOffset = CGSize(width: 0, height: 0)
        tabBar.layer.shadowRadius = 2.5
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.3
        viewControllers = [mainVC, mapVC, signInVc]
    }
    
    private func setBackButton() {
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
    }
}
