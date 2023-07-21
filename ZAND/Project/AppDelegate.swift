//
//  AppDelegate.swift
//  ZAND
//
//  Created by Василий on 13.04.2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupRouter()
        FirebaseApp.configure()

        AppRouter.shared.checkAuth()

        return true
    }
}

extension AppDelegate {

    // MARK: - Instance methods
    
    func setupRouter() {
        AppRouter.shared.appDelegate = self
    }
}
