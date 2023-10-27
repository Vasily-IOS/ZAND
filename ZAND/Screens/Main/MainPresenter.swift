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

    var selectedDays: [IndexPath: Bool] { get set }
    func getModel(by type: MainType) -> [CommonFilterProtocol]
    func getModel(by id: Int) -> SaloonMapModel?
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

    var selectedDays: [IndexPath: Bool] = [:]

    var sortedSaloons: [Saloon] = [] { // дата сорс коллекции
        didSet {
            view?.showEmptyLabel(isShow: sortedSaloons.isEmpty)
        }
    }

    var saloons: [Saloon] = []  // оставляем всегда нетронутым

    var optionsModel = OptionsModel.options

    private let network: APIManager
    
    // MARK: - Initializer
    
    init(view: MainViewInput, network: APIManager) {
        self.view = view
        self.network = network

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

    // срабатывает когда пользователь заходит в приложение и обновляет коллекцию только
    // тогда, когда фильтры пусты
    @objc
    private func updateDataSource() {
        if selectedDays.isEmpty {
            fetchData()
        }
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

    // либо это!!!!
    func backToInitialState() {
        sortedSaloons = saloons
    }

    func sortModel(filterID: Int) {
        sortedSaloons = saloons.filter({ $0.business_type_id == filterID })
    }

    // либо это!!!!
    func fetchData() {
        network.performRequest(type: .salons, expectation: Saloons.self
        ) { [weak self] saloonsData in
            guard let self else { return }

            self.sortedSaloons = saloonsData.data
            self.saloons = saloonsData.data
            self.view?.reloadData()
        }
    }

    func getModel(by type: MainType) -> [CommonFilterProtocol] {
        switch type {
        case .options:
            return optionsModel
        case .saloons:
            return sortedSaloons
        }
    }

    func getModel(by id: Int) -> SaloonMapModel? {
        return sortedSaloons.first(where: { $0.id == id })
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
        if let index = sortedSaloons.firstIndex(where: { $0.id == id }) {
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
            selector: #selector(updateDataSource),
            name: .updateData,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(connectivityStatus(_:)),
            name: .connecivityChanged, object: nil
        )
    }
}
