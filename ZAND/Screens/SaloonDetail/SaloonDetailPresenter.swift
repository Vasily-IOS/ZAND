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
    func getModel() -> Saloon
    func isInFavourite()
    func applyDB(completion: () -> ())
}

protocol SaloonViewInput: AnyObject {
    func updateUI(model: Saloon)
    func isInFavourite(result: Bool)
}

final class SaloonDetailPresenter: SaloonPresenterOutput {

    // MARK: - Properties

    weak var view: SaloonViewInput?

    var salonID: Int?

    var saloonName: String?

    var saloonAddress: String?

    private let model: Saloon

    // MARK: - Initializers

    init(view: SaloonViewInput, model: Saloon) {
        self.view = view

        self.model = model
        self.salonID = model.saloonCodable.remoteId
        self.saloonName = model.saloonCodable.title
        self.saloonAddress = model.saloonCodable.address

        view.updateUI(model: model)
    }

    // MARK: - Instance methods

    func getModel() -> Saloon {
        return model
    }

    func isInFavourite() {
        view?.isInFavourite(
            result: !FavouritesSalonsManager.shared.contains(modelID: model.saloonCodable.id)
        )
    }

    func applyDB(completion: () -> ()) {
        let id = model.saloonCodable.id
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
