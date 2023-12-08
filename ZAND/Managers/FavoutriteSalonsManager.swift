//
//  FavouritesSalonsManager.swift
//  ZAND
//
//  Created by Василий on 26.10.2023.
//

import Foundation

final class FavouritesSalonsManager {

    // MARK: - Properties

    private let saloonStorageKey = "saloonStorageKey"

    static let shared = FavouritesSalonsManager()

    var storageID: [Int] = [] {
        didSet {
            save(model: storageID, key: saloonStorageKey)
        }
    }

    // MARK: - Initializers

    private init() {
        self.storageID = loadStorageID()
    }

    // MARK: - Instance methods

    func save(model: [Int], key: String) {
        UserDefaults.standard.set(model, forKey: saloonStorageKey)
    }

    func add(modelID: Int) {
        if !contains(modelID: modelID) {
            storageID.append(modelID)
        }
        createNotification()
    }

    func loadStorageID() -> [Int] {
        return UserDefaults.standard.array(forKey: saloonStorageKey) as? [Int] ?? []
    }

    func delete(modelID: Int) {
        if let index = storageID.firstIndex(where: { $0 == modelID }) {
            storageID.remove(at: index)
            createNotification()
        }
    }

    func contains(modelID: Int) -> Bool {
        return storageID.contains(where: { $0 == modelID })
    }

    private func createNotification() {
        NotificationCenter.default.post(name: .storageIDidChanged, object: nil)
    }
}
