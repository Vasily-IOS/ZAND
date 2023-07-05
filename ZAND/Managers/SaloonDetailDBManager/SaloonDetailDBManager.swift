//
//  SaloonDetailDBManager.swift
//  ZAND
//
//  Created by Василий on 05.07.2023.
//

import UIKit
//import RealmSwift

final class SaloonDetailDBManager {

    // MARK: - Properties

    static let shared = SaloonDetailDBManager()

    private let realmManager: RealmManager = RealmManagerImpl()

    // MARK: - Initializers

    private init() {}

    // MARK: - Instance methods

    func save(modelForSave: SaloonMockModel) {
        let modelDB = DetailModelDB()
        modelDB.id = modelForSave.id
        modelDB.saloon_name = modelForSave.saloon_name
        modelDB.rating = (modelForSave.rating).toData() ?? Data()
        modelDB.image = (modelForSave.image).toData() ?? Data()
        modelDB.category?.id = modelForSave.category.id
        modelDB.category?.name = modelForSave.category.name
        modelDB.adress = modelForSave.adress
        modelDB.coordinates = modelForSave.coordinates
        modelDB.descriptions = modelForSave.description
        modelDB.weekend = modelForSave.weekend
        modelDB.weekdays = modelForSave.weekdays
        modelDB.scores = modelForSave.scores
        modelDB.min_price = modelForSave.min_price

        for photo in modelForSave.photos {
            photo.toData { resultData in
                modelDB.photos.append(resultData)
            }
        }
        
        realmManager.save(object: modelDB)
        VibrationManager.shared.vibrate(for: .success)
    }
}
