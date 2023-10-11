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
    var selectedDays: [IndexPath: Bool] { get set }
    func getModel(by type: MainType) -> [CommonFilterProtocol]
    func getSearchIndex(id: Int) -> IndexPath?
    func getModel(by id: Int) -> SaloonMapModel?
    func applyDB(by id: Int, completion: @escaping () -> ())
    func notContains(by id: Int) -> Bool
    func updateUI()

    func sortModel(filterID: Int)
}

protocol MainViewInput: AnyObject {
    func hideTabBar()
    func changeFavouritesAppearence(indexPath: IndexPath)
    func updateUI(model: [Saloon])
    func isActivityIndicatorShouldRotate(_ isRotate: Bool)
    func updateUIConection(isUpdate: Bool)
    func getOptions(model: [OptionsModel])

    func updateWithSortModel(model: [Saloon])
}

final class MainPresenter: MainPresenterOutput {

    // MARK: - Properties

    weak var view: MainViewInput?

    // to presenter
    var selectedDays: [IndexPath: Bool] = [:]
    
    private let optionsModel = OptionsModel.options

    private var saloons: [Saloon] = []

    private let realmManager: RealmManager

    private let provider: SaloonProvider
    
    // MARK: - Initializer
    
    init(view: MainViewInput, realmManager: RealmManager, provider: SaloonProvider) {
        self.view = view
        self.realmManager = realmManager
        self.provider = provider

        updateUI()
        subscribeNotifications()
        view.getOptions(model: optionsModel)
    }

    // MARK: - Action

    @objc
    private func hideTabBarNotificationAction(_ notification: Notification) {
        view?.hideTabBar()
        NotificationCenter.default.removeObserver(self)
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
        if let isConnected = notification.userInfo?["connectivityStatus"] as? Bool {
            view?.updateUIConection(isUpdate: isConnected)
        }
    }
}

extension MainPresenter {
    
    // MARK: - Instance methods

    func sortModel(filterID: Int) {
        let model = saloons.filter({ $0.business_type_id == filterID })
        view?.updateWithSortModel(model: model)
    }

    func updateUI() {
        provider.fetchData { [weak self] saloons in
            guard let self else { return }

            self.saloons = saloons
            self.view?.updateUI(model: saloons)
        }
    }

    func getSearchIndex(id: Int) -> IndexPath? {
        if let index = saloons.firstIndex(where: { $0.id == id }) {
            return [1, index]
        }
        return nil
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
        if self.notContains(by: id) {
            if let modelForSave = self.getModel(by: id) as? Saloon {
                SaloonDetailDBManager.shared.save(modelForSave: modelForSave)
            }
        } else {
            self.remove(by: id)
        }
        completion()
    }

    func remove(by id: Int) {
        let predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        realmManager.removeObjectByPredicate(object: SaloonDataBaseModel.self, predicate: predicate)
        VibrationManager.shared.vibrate(for: .success)
    }

    func notContains(by id: Int) -> Bool {
        let predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        return realmManager.contains(predicate: predicate, SaloonDataBaseModel.self)
    }

    // MARK: - Private

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
