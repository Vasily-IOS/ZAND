//
//  SaloonDetailPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

protocol SaloonPresenterOutput: AnyObject {
    var salonID: Int? { get }
    func getModel() -> Saloon?
    func getDBModel() -> SaloonMapModel?
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

    var salonID: Int?

    private var apiModel: Saloon?

    private var modelDB: SaloonDataBaseModel?

    private let realmManager: RealmManager

    // MARK: - Initializers

    init(view: SaloonViewInput, type: SaloonDetailType, realmManager: RealmManager) {
        self.view = view
        self.realmManager = realmManager

        switch type {
        case .api(let apiModel):
            self.apiModel = apiModel
            self.salonID = apiModel.id
        case .dataBase(let modelDB):
            self.modelDB = modelDB
            self.salonID = modelDB.id
        }

        view.updateUI(type: type)
    }

    // MARK: - Instance methods

    func getModel() -> Saloon? {
        guard let apiModel else { return nil }

        return apiModel
    }

    func getDBModel() -> SaloonMapModel? {
        guard let modelDB else { return nil }

        return modelDB
    }

    func isInFavourite() {
        guard let apiModel else { return }

        let predicate = NSPredicate(format: "id == %@", NSNumber(value: apiModel.id))
        view?.isInFavourite(result: realmManager.contains(predicate: predicate, SaloonDataBaseModel.self))
    }

    func applyDB(completion: () -> ()) {
        guard let modelForSave = apiModel else { return }

        if contains(by: modelForSave.id) {
            SaloonDetailDBManager.shared.save(modelForSave: modelForSave)
            sendNotification(userId: modelForSave.id, isInFavourite: true)
            completion()
        } else {
            remove(by: modelForSave.id)
            sendNotification(userId: modelForSave.id, isInFavourite: false)
            completion()
        }
        VibrationManager.shared.vibrate(for: .success)
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

    private func sendNotification(userId: Int, isInFavourite: Bool) {
        NotificationCenter.default.post(
            name: .isInFavourite,
            object: nil,
            userInfo: ["userId": userId, "isInFavourite": isInFavourite]
        )
    }
}
