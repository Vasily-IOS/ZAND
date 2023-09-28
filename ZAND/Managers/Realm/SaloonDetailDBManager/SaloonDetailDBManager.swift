//
//  SaloonDetailDBManager.swift
//  ZAND
//
//  Created by Василий on 05.07.2023.
//

import UIKit
import Kingfisher
import RealmSwift

final class SaloonDetailDBManager {

    // MARK: - Properties

    static let shared = SaloonDetailDBManager()

    private let realmManager: RealmManager = RealmManagerImpl()

    // MARK: - Initializers

    private init() {}

    // MARK: - Instance methods

    func save(modelForSave: Saloon) {
        let modelDB = SaloonDataBaseModel()
        modelDB.id = modelForSave.id
        modelDB.title = modelForSave.title
        modelDB.coordinate_lon = modelForSave.coordinate_lon
        modelDB.coordinate_lat = modelForSave.coordinate_lat
        modelDB.public_title = modelForSave.public_title
        modelDB.descriptionDB = modelForSave.description
        modelDB.schedule = modelForSave.schedule
        modelDB.address = modelForSave.address
        modelDB.bookforms.first?.id = modelForSave.bookforms.first?.id ?? 0
        modelDB.bookforms.first?.title = modelForSave.bookforms.first?.title ?? ""
        modelDB.bookforms.first?.url = modelForSave.bookforms.first?.url ?? ""
        modelDB.bookforms.first?.is_default = modelForSave.bookforms.first?.is_default ?? 0

        for photo in modelForSave.company_photos {
            let data = try? Data(contentsOf: URL(string: photo)!)
            modelDB.company_photos.append(data ?? Data())
        }

        realmManager.save(object: modelDB)
//        VibrationManager.shared.vibrate(for: .success)
    }
}
