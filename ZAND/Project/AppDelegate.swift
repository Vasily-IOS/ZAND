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

        // сетим сервис авторизации
        AGCInstance.startUp()
        // сетим роутер
        setupRouter()

        print(AGCAuth.instance().currentUser)

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
