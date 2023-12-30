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
        delete()
        
        let userDB = UserDataBaseModel()
        userDB.name = user.data.firstName
        userDB.surname = user.data.lastName
        userDB.fathersName = user.data.middleName
        userDB.email = user.data.email
        userDB.phone = user.data.phone
        userDB.birthday = user.data.birthday

        realmManager.save(object: userDB)
    }

    func get() -> UserDataBaseModel? {
        return realmManager.get(UserDataBaseModel.self).first
    }

    func isUserContains() -> Bool {
        return !realmManager.get(UserDataBaseModel.self).isEmpty
    }

    func delete() {
        realmManager.removeAll()
    }
}
