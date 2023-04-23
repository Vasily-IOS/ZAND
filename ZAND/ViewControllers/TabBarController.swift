//
//  TabBarController.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: - Properties
    
    private let vcFactory: DefaultVCFactory = VCFactory()
    
    // MARK: - Initializers
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
    }
}

extension TabBarController {
    
    // MARK: - Instance methods
    
    private func setViews() {
        let layoutBuilder: LayoutBuilderProtocol = LayoutBuilder()
        let mainView = MainView(layoutBuilder: layoutBuilder)
        let mainVC = MainViewController(contentView: mainView)
        mainVC.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(named: "main_icon"), selectedImage: nil)

        let mapView = MapView()
        let mapVC = MapViewController(contentView: mapView)
        mapVC.tabBarItem = UITabBarItem(title: "Карта", image: UIImage(named: "map_icon"), selectedImage: nil)
        
        let signInView = SignInView()
        let signInVc = SignInViewController(contentView: signInView)
        signInVc.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(named: "profile_icon"), selectedImage: nil)
        
        [mainVC, mapVC, signInVc].forEach {
            $0.navigationController?.isNavigationBarHidden = true
        }
    
        UITabBar.appearance().tintColor = .mainGreen
        UITabBar.appearance().backgroundColor = .white
        UITabBar.appearance().itemPositioning = .centered
        viewControllers = [mainVC, mapVC, signInVc]
    }
}
