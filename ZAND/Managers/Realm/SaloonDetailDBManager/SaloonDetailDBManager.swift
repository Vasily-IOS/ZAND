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

    func baseInfoRequest(modelForSave: Saloon, completion: @escaping (SaloonDataBaseModel) -> Void) {
        let modelDB = SaloonDataBaseModel()
        let group = DispatchGroup()

        group.enter()
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
        group.leave()

        group.notify(queue: .main) {
            completion(modelDB)
        }
    }

    func photoRequest(model: Saloon, completion: @escaping ([Data]) -> Void) {
        var arr: [Data?] = Array(repeating: nil, count: model.company_photos.count)
        let group = DispatchGroup()

        for (index, photo) in model.company_photos.enumerated() {
            group.enter()
            photo.imageToData { image in
                arr[index] = image ?? Data()
                group.leave()
            }
        }

        group.notify(queue: .main) {
            let sortedArr = arr.compactMap { $0 }
            completion(sortedArr)
        }
    }

    func save(modelForSave: Saloon) {
        var sortBaseModel = SaloonDataBaseModel()
        let group = DispatchGroup()

        group.enter()
        baseInfoRequest(modelForSave: modelForSave) { baseModel in
            sortBaseModel = baseModel
            group.leave()
        }

        group.enter()
        photoRequest(model: modelForSave) { photoData in
            sortBaseModel.company_photos.append(objectsIn: photoData)
            group.leave()
        }

        group.notify(queue: .main) {
            self.realmManager.save(object: sortBaseModel)
            print("Saved")
        }
    }
}
