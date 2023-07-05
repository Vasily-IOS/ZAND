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
    func getModel(by id: Int) -> SaloonMockModel?
    func applyDB(by id: Int, completion: () -> ())
    func contains(by id: Int) -> Bool
    func checkIsUserLaunched()
}

protocol MainViewInput: AnyObject {
    func hideTabBar()
    func checkIsUserLaunched(result: Bool)
    func changeFavouritesAppearence(indexPath: IndexPath)
}

final class MainPresenter: MainPresenterOutput {

    // MARK: - Properties
    
    private let optionsModel = OptionsModel.options

    private let saloonsModel = SaloonMockModel.saloons

    private let realmManager: RealmManager
    
    // MARK: - UI
    
    weak var view: MainViewInput?
    
    // MARK: - Initializer
    
    init(view: MainViewInput, realmManager: RealmManager) {
        self.view = view
        self.realmManager = realmManager

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

    func getSearchIndex(id: Int) -> IndexPath? {
        if let index = saloonsModel.firstIndex(where: { $0.id == id }) {
            return [1, index]
        }
        return nil
    }

    func getModel(by type: MainType) -> [CommonFilterProtocol] {
        switch type {
        case .options:
            return optionsModel
        case .saloons:
            return saloonsModel
        }
    }

    func getModel(by id: Int) -> SaloonMockModel? {
        return saloonsModel.first(where: { $0.id == id })
    }

    func applyDB(by id: Int, completion: () -> ()) {
        if contains(by: id) {
            let modelForSave = getModel(by: id)

            let modelDB = DetailModelDB()
            modelDB.id = modelForSave?.id ?? 0
            modelDB.saloon_name = modelForSave?.saloon_name ?? ""
            modelDB.rating = (modelForSave?.rating)?.toData() ?? Data()
            modelDB.image = (modelForSave?.image ?? UIImage()).toData() ?? Data()
            modelDB.category?.id = modelForSave?.category.id ?? 0
            modelDB.category?.name = modelForSave?.category.name ?? ""
            modelDB.adress = modelForSave?.adress ?? ""
            modelDB.coordinates = modelForSave?.coordinates ?? ""
            modelDB.descriptions = modelForSave?.description ?? ""
            modelDB.weekend = modelForSave?.weekend ?? ""
            modelDB.weekdays = modelForSave?.weekdays ?? ""
            modelDB.scores = modelForSave?.scores ?? 0
            modelDB.min_price = modelForSave?.min_price ?? 0

            for photo in (modelForSave?.photos ?? []) {
                photo.toData { resultData in
                    modelDB.photos.append(resultData)
                }
            }

            realmManager.save(object: modelDB)
            VibrationManager.shared.vibrate(for: .success)
            completion()
        } else {
            remove(by: id)
            completion()
        }
    }

    func remove(by id: Int) {
        let predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        realmManager.removeObjectByID(object: DetailModelDB.self, predicate: predicate)
    }

    func contains(by id: Int) -> Bool {
        let predicate = NSPredicate(format: "id == %@", NSNumber(value: id))
        return realmManager.contains(predicate: predicate, DetailModelDB.self)
    }

    func checkIsUserLaunched() {
        view?.checkIsUserLaunched(result: OnboardManager.shared.isUserFirstLaunch())
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
