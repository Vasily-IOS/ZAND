//
//  SettingsPresenter.swift
//  ZAND
//
//  Created by Василий on 29.12.2023.
//

import Foundation

enum SaveType {
    case all
    case email
    case `default`
}


protocol SettingsOutput: AnyObject {
    var view: SettingsInput { get set }
    var saveType: SaveType { get set }
    var name: String? { get set }
    var surname: String? { get set }
    var fathersName: String? { get set }
    var birthday: String? { get set }
    var phone: String? { get set }
    var email: String? { get set }

    func save()
}

protocol SettingsInput: AnyObject {
    func configure(model: UserDataBaseModel)
    func changeUIAppearing(type: SaveType)
    func showSmthWentWrongAlert()
}

final class SettingsPresenter: SettingsOutput {

    // MARK: - Properties

    var saveType: SaveType = .default {
        didSet {
            view.changeUIAppearing(type: saveType)
        }
    }

    var name: String?

    var surname: String?

    var fathersName: String?

    var birthday: String?

    var phone: String?

    var email: String?

    unowned var view: SettingsInput

    private let network: APIManagerAuthP

    // MARK: - Initializers

    init(view: SettingsInput, network: APIManagerAuthP) {
        self.view = view
        self.network = network

        if let userModel = UserDBManager.shared.get() {
            view.configure(model: userModel)
        }
    }

    // MARK: - Instance methods

    func save() {
        switch saveType {
        case .all:
            changeUserData()
        case .email:
            changeUserEmail()
        case .default:
            break
        }
    }

    private func changeUserData() {
        guard let savedUser = UserDBManager.shared.get() else { return }

        let refreshModel = RefreshUserModel(
            lastName: surname ?? savedUser.surname,
            middleName: fathersName ?? savedUser.fathersName,
            firstName: name ?? savedUser.name ,
            phone: phone ?? savedUser.phone,
            birthday: birthday ?? savedUser.birthday
        )

        network.performRequest(
            type: .refreshUser(refreshModel),
            expectation: UserModel.self
        ) { [weak self] user, isSuccess in
            guard let self else { return }

            if isSuccess {
                if let user = user {
                    UserDBManager.shared.save(user: user)
                }
                NotificationCenter.default.post(name: .canUpdateProfile, object: nil)
            } else {
                view.showSmthWentWrongAlert()
            }
        }
    }

    private func changeUserEmail() {
//        print("Change user email")
    }
}
