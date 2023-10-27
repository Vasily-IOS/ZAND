//
//  SaloonDetailPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation
import UIKit

protocol SaloonPresenterOutput: AnyObject {
    var salonID: Int? { get }
    var saloonName: String? { get }
    var saloonAddress: String? { get }
    func getModel() -> Saloon?
//    func getDBModel() -> SaloonMapModel?
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

    var saloonName: String?

    var saloonAddress: String?

    private var apiModel: Saloon?

    // MARK: - Initializers

    init(view: SaloonViewInput, type: SaloonDetailType) {
        self.view = view

        switch type {
        case .api(let apiModel):
            self.apiModel = apiModel
            self.salonID = apiModel.id
            self.saloonName = apiModel.title
            self.saloonAddress = apiModel.address
        }

        view.updateUI(type: type)
    }

    // MARK: - Instance methods

    func getModel() -> Saloon? {
        guard let apiModel else { return nil }

        return apiModel
    }

    func isInFavourite() {
        guard let apiModel else { return }

        view?.isInFavourite(result: !FavouritesSalonsManager.shared.contains(modelID: apiModel.id))
    }

    func applyDB(completion: () -> ()) {
        guard let modelForSave = apiModel else { return }

        let id = modelForSave.id
        let storageManager = FavouritesSalonsManager.shared

        if storageManager.contains(modelID: id) {
            storageManager.delete(modelID: id)
            sendNotification(userId: id, isInFavourite: true)
        } else {
            storageManager.add(modelID: id)
            sendNotification(userId: id, isInFavourite: false)
        }
        VibrationManager.shared.vibrate(for: .success)
        completion()
    }

    func contains(by id: Int) -> Bool {
        return !FavouritesSalonsManager.shared.contains(modelID: id)
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
