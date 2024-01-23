//
//  AppDelegate.swift
//  ZAND
//
//  Created by Василий on 13.04.2023.
//

import UIKit
import YandexMobileMetrica

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        setupRouter()
        NetworkMonitor.shared.startMonitoring()

        let configuration = YMMYandexMetricaConfiguration.init(apiKey: ID.yandexID)
        YMMYandexMetrica.activate(with: configuration!)

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        TokenManager.shared.appDelegate = self
    }
}

extension AppDelegate {

    // MARK: - Instance methods
    
    func setupRouter() {
        AppRouter.shared.appDelegate = self
    }
}
