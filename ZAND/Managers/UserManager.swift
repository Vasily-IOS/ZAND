//
//  UserManager.swift
//  ZAND
//
//  Created by Василий on 30.12.2023.
//

import Foundation

final class UserManager {

    // MARK: - Properties

    static let shared = UserManager()

    private let decoder = JSONDecoder()

    private let encoder = JSONEncoder()

    private let key = "user_key"

    // MARK: - Initializers

    private init() {}

    // MARK: - Instance methods

    func save(user: UserModel) {
        let model = UserDBModel(
            name: user.data.firstName,
            surname: user.data.lastName,
            fathersName: user.data.middleName,
            birthday: user.data.birthday,
            phone: user.data.phone,
            email: user.data.email
        )
        let data = try! encoder.encode(model)
        UserDefaults.standard.set(data, forKey: key)
    }

    func get() -> UserDBModel? {
        let data = UserDefaults.standard.data(forKey: key)
        do {
           return try decoder.decode(UserDBModel.self, from: data ?? Data())
        } catch let error {
            debugPrint(error)
            return nil
        }
    }

    func delete() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
