//
//  MainPresenter.swift
//  ZAND
//
//  Created by Василий on 07.06.2023.
//

import UIKit
import RealmSwift

enum MainType {
    case options
    case saloons
}

protocol MainPresenterOutput: AnyObject {
    var sortedSaloons: [Saloon] { get set }
    var optionsModel: [OptionsModel] { get }
    var selectedFilters: [IndexPath: Bool] { get set }
    var isFirstLaunch: Bool { get set }

    func getModel(by id: Int) -> Saloon?
    func applyDB(by id: Int, completion: @escaping () -> ())
    func contains(by id: Int) -> Bool
    func fetchData()
    func backToInitialState()
    func sortModel(filterID: Int)
}

protocol MainViewInput: AnyObject {
    func hideTabBar()
    func changeFavouritesAppearence(indexPath: IndexPath)
    func isActivityIndicatorShouldRotate(_ isRotate: Bool)
    func updateUIConection(isConnected: Bool)
    func reloadData()
    func showEmptyLabel(isShow: Bool)
}

final class MainPresenter: MainPresenterOutput {

    // MARK: - Properties

    weak var view: MainViewInput?

    var selectedFilters: [IndexPath: Bool] = [:] {
        didSet {
            print(selectedFilters)
        }
    }

    var sortedSaloons: [Saloon] = [] { // дата сорс коллекции
        didSet {
            view?.showEmptyLabel(isShow: sortedSaloons.isEmpty)
        }
    }

    var saloons: [Saloon] = []  // оставляем всегда нетронутым

    var optionsModel = OptionsModel.options

    var isFirstLaunch = true

    private let provider: SaloonProvider

    // MARK: - Initializer
    
    init(view: MainViewInput, provider: SaloonProvider) {
        self.view = view
        self.provider = provider

        self.subscribeNotifications()
    }

    // MARK: - Action

    @objc
    private func hideTabBarNotificationAction(_ notification: Notification) {
        view?.hideTabBar()
    }

    @objc
    private func isInFavouriteNotificationAction(_ notification: Notification) {
        guard let userId = notification.userInfo?["userId"] as? Int else { return }

        view?.changeFavouritesAppearence(indexPath: (getSearchIndex(id: userId) ?? [0, 0]))
    }

    @objc
    private func connectivityStatus(_ notification: Notification) {
        if let isConnected = notification.userInfo?[Config.connectivityStatus] as? Bool {
            self.view?.updateUIConection(isConnected: isConnected)
        }
    }
}

extension MainPresenter {
    
    // MARK: - Instance methods

    func backToInitialState() {
        sortedSaloons = saloons
    }

    func sortModel(filterID: Int) {
        sortedSaloons = saloons.filter({ $0.saloonCodable.business_type_id == filterID })
    }

    func fetchData() {
        provider.fetchData { [weak self] saloons in
            self?.sortedSaloons = saloons
            self?.saloons = saloons
            self?.view?.reloadData()
        }
    }

    func getModel(by id: Int) -> Saloon? {
        return sortedSaloons.first(where: { $0.saloonCodable.id == id })
    }

    func applyDB(by id: Int, completion: @escaping () -> ()) {
        let storageManager = FavouritesSalonsManager.shared

        if storageManager.contains(modelID: id) {
            storageManager.delete(modelID: id)
        } else {
            storageManager.add(modelID: id)
        }
        VibrationManager.shared.vibrate(for: .success)
        completion()
    }

    func contains(by id: Int) -> Bool {
        return !FavouritesSalonsManager.shared.contains(modelID: id)
    }

    // MARK: - Private

    private func getSearchIndex(id: Int) -> IndexPath? {
        if let index = sortedSaloons.firstIndex(where: { $0.saloonCodable.id == id }) {
            return [1, index]
        }
        return nil
    }

    private func subscribeNotifications() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(isInFavouriteNotificationAction(_ :)),
            name: .isInFavourite,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideTabBarNotificationAction(_:)),
            name: .showTabBar,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(connectivityStatus(_:)),
            name: .connecivityChanged, object: nil
        )
    }
}
