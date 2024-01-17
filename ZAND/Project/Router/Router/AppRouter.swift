//
//  AppRouter.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit
import AuthenticationServices

enum ReplacedControllerType {
    case signIn
    case profile
}

final class AppRouter {

    // MARK: - Properties
    
    static let shared: DefaultRouter = AppRouter()

    var appDelegate: AppDelegate? {
        didSet {
            setup()
        }
    }

    private var navigationController = UINavigationController()

    private var tabBarController: UITabBarController?

    private var createRecordNavigationController: UINavigationController?

    private let vcFactory: ViewControllerFactory = ViewControllerFactoryImpl()

    // MARK: - Initializers
    
    private init() {}
}

extension AppRouter {
    
    // MARK: - Instance methods

    func switchRoot(type: ReplacedControllerType) {
        guard
            let window = appDelegate?.window,
            let rootController = window.rootViewController as? UINavigationController,
            let tabBarController = rootController.viewControllers.first as? UITabBarController
        else { return }

        let tabBarItem = UITabBarItem(
            title: AssetString.profile.rawValue,
            image: AssetImage.profile_icon.image,
            selectedImage: nil
        )

        switch type {
        case .profile:
            let profileViewController = vcFactory.getViewController(for: .profile)
            profileViewController.tabBarItem = tabBarItem
            tabBarController.viewControllers?[2] = profileViewController
        case .signIn:
            let signInViewController = vcFactory.getViewController(for: .signIn)
            signInViewController.tabBarItem = tabBarItem
            tabBarController.viewControllers?[2] = signInViewController
        }
    }

    private func setup() {
        let videoVC = LaunchVideoScreenViewController()
        let tabBar = vcFactory.getViewController(for: .tabBar)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
            UIView.animate(withDuration: 0.2) {
                self.tabBarController = tabBar as? UITabBarController
                self.navigationController = UINavigationController(rootViewController: tabBar)
                self.navigationController.isNavigationBarHidden = false
                self.navigationController.navigationBar.tintColor = .white
                
                self.appDelegate?.window?.rootViewController = self.navigationController
                self.setupNavigationbar()
                self.appDelegate?.window?.makeKeyAndVisible()
            }
        }

        appDelegate?.window = UIWindow(frame: UIScreen.main.bounds)
        appDelegate?.window?.backgroundColor = .black
        appDelegate?.window?.rootViewController = videoVC
        setupNavigationbar()
        appDelegate?.window?.makeKeyAndVisible()
    }
    
    private func setupNavigationbar() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.black
        ]
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        appearance.configureWithTransparentBackground()
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.tintColor = UIColor(red: 0, green: 0, blue: 0.2, alpha: 1)
    }
}

extension AppRouter: DefaultRouter {

    // MARK: - DefaultRouter methods
    
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
    
    func dismiss() {
        navigationController.dismiss(animated: true)
    }
    
    func presentRecordNavigation(type: VCType) {
        let viewController = vcFactory.getViewController(for: type)
        createRecordNavigationController = UINavigationController(rootViewController: viewController)
        navigationController.present(createRecordNavigationController!, animated: true)
    }
    
    func presentSearch(type: VCType, completionHandler: ((SearchState, SaloonModel?) -> ())?) {
        let vc = vcFactory.getViewController(for: type) as! SearchViewController
        vc.completionHandler = completionHandler
        navigationController.present(vc, animated: true)
    }

    func presentFilterVC(type: VCType, completion: @escaping ([IndexPath : Bool], Bool) -> Void) {
        let vc = vcFactory.getViewController(for: type) as! FilterViewController
        vc.completionHandler = completion
        navigationController.present(vc, animated: true)
    }

    func showAlert(type: AlertType, message: String?) {
        let alertController = UIAlertController(title: type.textValue, message: message, preferredStyle: .alert)
        let understandAction = UIAlertAction(title: AssetString.ok.rawValue, style: .cancel)
        alertController.addAction(understandAction)
        navigationController.present(alertController, animated: true)
    }

    func pushCreateRecord(_ type: VCType) {
        let viewController = vcFactory.getViewController(for: type)
        createRecordNavigationController?.pushViewController(viewController, animated: true)
    }

    func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }
}
