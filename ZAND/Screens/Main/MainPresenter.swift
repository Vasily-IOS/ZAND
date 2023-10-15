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
    var saloons: [Saloon] { get set }
    var optionsModel: [OptionsModel] { get }

    var selectedDays: [IndexPath: Bool] { get set }
    func getModel(by type: MainType) -> [CommonFilterProtocol]
    func getModel(by id: Int) -> SaloonMapModel?
    func applyDB(by id: Int, completion: @escaping () -> ())
    func contains(by id: Int) -> Bool
    func updateUI()
    func backToInitialState()
    func sortModel(filterID: Int)
}

protocol MainViewInput: AnyObject {
    func hideTabBar()
    func changeFavouritesAppearence(indexPath: IndexPath)
    func isActivityIndicatorShouldRotate(_ isRotate: Bool)
    func updateUIConection(isConnected: Bool)
    func reloadData()
}

final class MainPresenter: MainPresenterOutput {

    // MARK: - Properties

    weak var view: MainViewInput?

    var selectedDays: [IndexPath: Bool] = [:]

    var saloons: [Saloon] = [] // дата сорс коллекции

    var additiolSaloons: [Saloon] = []  // оставляем всегда нетронутым

    var optionsModel = OptionsModel.options
    
    private let realmManager: RealmManager

    private let provider: SaloonProvider
    
    // MARK: - Initializer
    
    init(view: MainViewInput, realmManager: RealmManager, provider: SaloonProvider) {
        self.view = view
        self.realmManager = realmManager
        self.provider = provider

        self.updateUI()
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
    private func updateData(_ nnotification: Notification) {
        if selectedDays.isEmpty {
            updateUI()
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

    func backToInitialState() {
        saloons = additiolSaloons
    }

    func sortModel(filterID: Int) {
        saloons = additiolSaloons.filter({ $0.business_type_id == filterID })
    }

    func updateUI() {
        provider.fetchData { [weak self] saloons in
            guard let self else { return }

            self.saloons = saloons
            self.additiolSaloons = saloons
            self.view?.reloadData()
        }
    }

    func getModel(by type: MainType) -> [CommonFilterProtocol] {
        switch type {
        case .options:
            return optionsModel
        case .saloons:
            return saloons
        }
    }

    func getModel(by id: Int) -> SaloonMapModel? {
        return saloons.first(where: { $0.id == id })
    }

    func applyDB(by id: Int, completion: @escaping () -> ()) {
        if self.contains(by: id) {
            if let modelForSave = self.getModel(by: id) as? Saloon {
                SaloonDetailDBManager.shared.save(modelForSave: modelForSave)
            }
        } else {
            self.remove(by: id)
        }
        VibrationManager.shared.vibrate(for: .success)
        completion()
    }

    func remove(by id: Int) {
        let predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        realmManager.removeObjectByPredicate(object: SaloonDataBaseModel.self, predicate: predicate)
    }

    func contains(by id: Int) -> Bool {
        let predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        return realmManager.contains(predicate: predicate, SaloonDataBaseModel.self)
    }

    // MARK: - Private

    private func getSearchIndex(id: Int) -> IndexPath? {
        if let index = saloons.firstIndex(where: { $0.id == id }) {
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
            selector: #selector(updateData(_ :)),
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
