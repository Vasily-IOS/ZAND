//
//  MainPresenter.swift
//  ZAND
//
//  Created by Василий on 07.06.2023.
//

import Foundation

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
}

protocol MainViewInput: AnyObject {

}

final class MainPresenter: MainPresenterOutput {
   
    // MARK: - Properties
    
    private let optionsModel = OptionsModel.options

    private var saloonsModel = SaloonMockModel.saloons

    private let realmManager: RealmManager
    
    // MARK: - UI
    
    weak var view: MainViewInput?
    
    // MARK: - Initializer
    
    init(view: MainViewInput, realmManager: RealmManager) {
        self.view = view
        self.realmManager = realmManager
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
}
