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

    func save()
}

protocol SettingsInput: AnyObject {
    func configure(model: UserDataBaseModel)
    func changeUIAppearing(type: SaveType)
}

final class SettingsPresenter: SettingsOutput {

    // MARK: - Properties

    var saveType: SaveType = .default {
        didSet {
            view.changeUIAppearing(type: saveType)
        }
    }

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
//        print("Change user data")
    }

    private func changeUserEmail() {
//        print("Change user email")
    }
}
