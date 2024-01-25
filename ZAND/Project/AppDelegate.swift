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
        setupYandexMetrica()

        NetworkMonitor.shared.startMonitoring()

        return true
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        TokenManager.shared.appDelegate = self
    }

    // MARK: - Instance methods

    private func setupYandexMetrica() {
        // По умолчанию AppMetrica отслеживает жизненный цикл приложения в автоматическом режиме.
        // Чтобы изменить длительность таймаута, передайте значение в секундах в свойство sessionTimeout конфигурации YMMYandexMetricaConfiguration.
        // По умолчанию длительность таймаута сессии равна 10 (у нас 120) секундам. Это минимально допустимое значение свойства sessionTimeout.

        let configuration = YMMYandexMetricaConfiguration.init(apiKey: ID.yandexID)
        configuration?.sessionTimeout = 120
        YMMYandexMetrica.activate(with: configuration!)
    }
}

extension AppDelegate {

    // MARK: - Instance methods
    
    func setupRouter() {
        AppRouter.shared.appDelegate = self
    }
}
