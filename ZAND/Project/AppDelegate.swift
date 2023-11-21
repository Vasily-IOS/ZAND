//
//  AppDelegate.swift
//  ZAND
//
//  Created by Василий on 13.04.2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        setupRouter()
        NetworkMonitor.shared.startMonitoring()

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        DeviceLocationService.shared.isAppActive = false
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        AppRouter.shared.checkAuth()
        DeviceLocationService.shared.isAppActive = true
    }
}

extension AppDelegate {

    // MARK: - Instance methods
    
    func setupRouter() {
        AppRouter.shared.appDelegate = self
    }
}
