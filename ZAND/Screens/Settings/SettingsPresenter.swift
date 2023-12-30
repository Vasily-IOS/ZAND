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
    func configure(model: UserDBModel)
    func changeUIAppearing(type: SaveType)
    func showSmthWentWrongAlert()
    func showEqualEmailAlert()
    func navigateToVerify()
    func dismiss()
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

        if let userModel = UserManager.shared.get() {
            view.configure(model: userModel)
        }

        subscribeNotification()
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

    // MARK: - Private methods

    @objc
    private func signOutAction() {
        view.dismiss()
    }

    private func changeUserData() {
        guard let savedUser = UserManager.shared.get() else { return }

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
                    UserManager.shared.save(user: user)
                }
                NotificationCenter.default.post(name: .canUpdateProfile, object: nil)
            } else {
                view.showSmthWentWrongAlert()
            }
        }
    }

    private func changeUserEmail() {
        guard let savedUser = UserManager.shared.get() else { return }

        if email?.trimmingCharacters(in: .whitespaces) ?? savedUser.email == savedUser.email {
            view.showEqualEmailAlert()
        } else {
            let emailModel = EmailModel(email: email ?? savedUser.email)

            network.performRequest(
                type: .refreshEmail(emailModel),
                expectation: ServerResponse.self) { [weak self] _, isSuccess in
                    guard let self else { return }

                    if isSuccess {
                        self.view.navigateToVerify()
                    } else {
                        self.view.showSmthWentWrongAlert()
                    }
                }
        }
    }

    private func subscribeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(signOutAction),
            name: .signOut,
            object: nil
        )
    }
}
