//
//  SaloonDetailPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

protocol SaloonPresenterOutput: AnyObject {
    func getModel() -> SaloonMockModel?
    func getDBModel() -> DetailModelDB?
    func isInFavourite()
    func applyDB(completion: () -> ())

}

protocol SaloonViewInput: AnyObject {
    func updateUI(type: SaloonDetailType)
    func isInFavourite(result: Bool)
}

final class SaloonDetailPresenter: SaloonPresenterOutput {

    // MARK: - Properties

    weak var view: SaloonViewInput?

    private var apiModel: SaloonMockModel?

    private var modelDB: DetailModelDB?

    private let realmManager: RealmManager

    // MARK: - Initializers

    init(view: SaloonViewInput, type: SaloonDetailType, realmManager: RealmManager) {
        self.view = view
        self.realmManager = realmManager

        switch type {
        case .apiModel(let apiModel):
            self.apiModel = apiModel
        case .dbModel(let modelDB):
            self.modelDB = modelDB
        }

        view.updateUI(type: type)
    }

    // MARK: - Instance methods

    func getModel() -> SaloonMockModel? {
        guard let apiModel else { return nil }

        return apiModel
    }

    func getDBModel() -> DetailModelDB? {
        guard let modelDB else { return nil }

        return modelDB
    }

    func isInFavourite() {
        guard let apiModel else { return }

        let predicate = NSPredicate(format: "id == %@", NSNumber(value: apiModel.id))
        view?.isInFavourite(result: realmManager.contains(predicate: predicate, DetailModelDB.self))
    }

    func applyDB(completion: () -> ()) {
        guard let apiModel else { return }

        if contains(by: apiModel.id) {
            let modelDB = DetailModelDB()
            modelDB.id = apiModel.id
            modelDB.saloon_name = apiModel.saloon_name
            realmManager.save(object: modelDB)

            sendNotification(userId: apiModel.id, isInFavourite: true)
            VibrationManager.shared.vibrate(for: .success)

            completion()
        } else {
            remove(by: apiModel.id)

            sendNotification(userId: apiModel.id, isInFavourite: false)

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

    // MARK: - Private

    private func sendNotification(userId: Int, isInFavourite: Bool) {
        NotificationCenter.default.post(
            name: .isInFavourite,
            object: nil,
            userInfo: ["userId": userId, "isInFavourite": isInFavourite]
        )
    }
}
