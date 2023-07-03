//
//  SaloonDetailPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

protocol SaloonPresenterOutput: AnyObject {
    func updateUI()
    func getModel() -> SaloonMockModel
    func isInFavourite()
    func applyDB(completion: () -> ())
}

protocol SaloonViewInput: AnyObject {
    func updateUI(model: SaloonMockModel)
    func isInFavourite(result: Bool)
}

final class SaloonDetailPresenter: SaloonPresenterOutput {

    // MARK: - Properties

    weak var view: SaloonViewInput?

    private let model: SaloonMockModel

    private let realmManager: RealmManager

    // MARK: - Initializers

    init(view: SaloonViewInput, model: SaloonMockModel, realmManager: RealmManager) {
        self.view = view
        self.model = model
        self.realmManager = realmManager
    }

    // MARK: - Instance methods

    func updateUI() {
        view?.updateUI(model: model)
    }

    func getModel() -> SaloonMockModel {
        return model
    }

    func isInFavourite() {
        let predicate = NSPredicate(format: "id == %@", NSNumber(value: model.id))
        view?.isInFavourite(result: realmManager.contains(predicate: predicate, DetailModelDB.self))
    }

    func applyDB(completion: () -> ()) {
        if contains(by: model.id) {
            let modelDB = DetailModelDB()
            modelDB.id = model.id
            modelDB.saloon_name = model.saloon_name
            realmManager.save(object: modelDB)

            VibrationManager.shared.vibrate(for: .success)
            completion()

            print("Save")
        } else {
            print("Remove")
            remove(by: model.id)
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
}
