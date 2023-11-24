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

    func save(user: UserModel) {
        let userDB = UserDataBaseModel()
        userDB.id = user.id
        userDB.givenName = user.name ?? ""
        userDB.familyName = user.surname ?? ""
        userDB.email = user.email ?? ""
        userDB.phone = user.phone ?? ""

        realmManager.save(object: userDB)
    }

    func get() -> UserDataBaseModel? {
        return realmManager.get(UserDataBaseModel.self).first
    }

    func isUserContains() -> Bool {
        return !realmManager.get(UserDataBaseModel.self).isEmpty
    }

    func exit() {
        if let object = realmManager.get(UserDataBaseModel.self).first {
            realmManager.removeObject(object: object)
        } else {
            print("Have no objects of this type")
        }
    }
}
