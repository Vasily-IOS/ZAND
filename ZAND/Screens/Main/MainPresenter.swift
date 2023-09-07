//
//  MainPresenter.swift
//  ZAND
//
//  Created by Василий on 07.06.2023.
//

import UIKit

enum MainType {
    case options
    case saloons
}

protocol MainPresenterOutput: AnyObject {
    func getModel(by type: MainType) -> [CommonFilterProtocol]
    func getSearchIndex(id: Int) -> IndexPath?
    func getModel(by id: Int) -> SaloonMapModel?
    func applyDB(by id: Int, completion: () -> ())
    func contains(by id: Int) -> Bool

    func fetchData()
}

protocol MainViewInput: AnyObject {
    func hideTabBar()
    func changeFavouritesAppearence(indexPath: IndexPath)
    func updateUI(model: [Saloon])
}

final class MainPresenter: MainPresenterOutput {

    // MARK: - Properties
    
    private let optionsModel = OptionsModel.options

    private var saloons: [Saloon] = []

    private let realmManager: RealmManager

    private let provider: SaloonProvider

    // MARK: - UI
    
    weak var view: MainViewInput?
    
    // MARK: - Initializer
    
    init(view: MainViewInput, realmManager: RealmManager, provider: SaloonProvider) {
        self.view = view
        self.realmManager = realmManager
        self.provider = provider

        subscribeTabBarNotification()
        subcribeFavouritesNotification()
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
}

extension MainPresenter {
    
    // MARK: - Instance methods

    func fetchData() {
        provider.fetchData { [weak self] saloons in
            self?.saloons = saloons
            self?.view?.updateUI(model: saloons)
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

    func applyDB(by id: Int, completion: () -> ()) {
        if contains(by: id) {
            if let modelForSave = getModel(by: id) {
//                SaloonDetailDBManager.shared.save(modelForSave: modelForSave)
                completion()
            }
        } else {
            remove(by: id)
            completion()
        }
    }

    func remove(by id: Int) {
        let predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        realmManager.removeObjectByID(object: DetailModelDB.self, predicate: predicate)
        VibrationManager.shared.vibrate(for: .success)
    }

    func contains(by id: Int) -> Bool {
        let predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        return realmManager.contains(predicate: predicate, DetailModelDB.self)
    }

    // MARK: - Private

    private func subcribeFavouritesNotification() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(isInFavouriteNotificationAction(_ :)),
            name: .isInFavourite,
            object: nil)
    }

    private func subscribeTabBarNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideTabBarNotificationAction(_:)),
            name: .showTabBar,
            object: nil
        )
    }
}
