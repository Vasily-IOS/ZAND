//
//  AppDelegate.swift
//  ZAND
//
//  Created by Василий on 13.04.2023.
//

import UIKit
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setupRouter()
        FirebaseApp.configure()

        if AuthManagerImpl.shared.isUserLogged() {
            print("User logged")
        } else {
            print("User is not logged")
        }

        return true
    }
}

extension AppDelegate {
    
    func setupRouter() {
        AppRouter.shared.appDelegate = self
    }
}
