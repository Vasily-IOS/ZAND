//
//  UserDBManager.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import UIKit

final class UserDBManager {

    // MARK: - Properties

    static let shared = UserDBManager()

    private let realmManager: RealmManager = RealmManagerImpl()

    // MARK: - Initializers

    private init() {}

    // MARK: - Instance methods

    func save(user: User) {
        let userDB = UserModelDB()
        userDB.id = user.id
        userDB.givenName = user.name
        userDB.familyName = user.surname
        userDB.email = user.email
        userDB.phone = user.phone

        realmManager.save(object: userDB)
    }

    func get() -> UserModelDB? {
        return realmManager.get(UserModelDB.self).first
    }

    func contains() -> Bool {
        return !realmManager.get(UserModelDB.self).isEmpty
    }

    func exit() {
        if let object = realmManager.get(UserModelDB.self).first {
            realmManager.removeObject(object: object)
        } else {
            print("Have no objects of this type")
        }
    }
}
