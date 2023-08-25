//
//  AppDelegate.swift
//  ZAND
//
//  Created by Василий on 13.04.2023.
//

import UIKit
import AGConnectCore
import AGConnectAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        // сетим роутер
        setupRouter()
        // сетим сервис авторизации
        AGCInstance.startUp()

        let user = AGCAuth.instance().currentUser
        print(user?.displayName)

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppRouter.shared.checkAuth()
    }
}

extension AppDelegate {

    // MARK: - Instance methods
    
    func setupRouter() {
        AppRouter.shared.appDelegate = self
    }
}
