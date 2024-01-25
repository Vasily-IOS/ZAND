//
//  SettingsPresenter.swift
//  ZAND
//
//  Created by Василий on 29.12.2023.
//

import Foundation

enum ChangeUserDataState {
    case success
    case failure(Int)
}


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
    func showIncorrectEmailAlert() // знаю знаю
    func showEqualEmailAlert()
    func showLessMinCountNimberAlert()
    func badInputNumberAlert()
    func showSmthWentWrongAlert()
    func changeDataAction(state: ChangeUserDataState)
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

    private let network: ZandAppAPI

    // MARK: - Initializers

    init(view: SettingsInput, network: ZandAppAPI) {
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

    private func isPhoneCorrect() -> Bool {
        guard let savedUser = UserManager.shared.get() else { return false }

        return ((phone ?? savedUser.phone).prefix(5) == "+7 (9")
    }

    private func isValidPhoneNumberCount() -> Bool {
        return (phone?.isEmpty ?? false) || phone?.count != 18
    }

    private func isEmailCorrect(email: String) -> Bool {
        let emailPattern = Regex.email
        let isEmailCorrect = email.range(of: emailPattern, options: .regularExpression)
        return (isEmailCorrect != nil)
    }

    // MARK: - Private methods

    @objc
    private func signOutAction() {
        view.dismiss()
    }

    private func changeUserData() {
        guard let savedUser = UserManager.shared.get() else { return }

        if isPhoneCorrect() == false || (phone ?? savedUser.phone).count != 18 {
            view.badInputNumberAlert()
        } else {
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
                    self.view.changeDataAction(state: .success)
                } 
//                else {
//                    view.showSmthWentWrongAlert()
//                }
            } error: { error in
                if let model = try? JSONDecoder().decode(ResponseError.self, from: error) {
                    if model.code == 1 {
                        self.view.changeDataAction(state: .failure(1))
                    }
                } else {
                    self.view.showSmthWentWrongAlert()
                }
            }
        }
    }

    private func changeUserEmail() {
        guard let savedUser = UserManager.shared.get() else { return }

        if email?.trimmingCharacters(in: .whitespaces) ?? savedUser.email == savedUser.email  {
            view.showEqualEmailAlert()
        } else if email?.isEmpty == true || (email?.count ?? 0) <= 10 {
            view.showIncorrectEmailAlert()
        } else {
            let emailModel = EmailModel(email: email ?? savedUser.email)

            network.performRequest(
                type: .refreshEmail(emailModel),
                expectation: ServerResponse.self) { [weak self] _, isSuccess in
                    guard let self else { return }

                    if isSuccess {
                        self.view.navigateToVerify()
                    } else {
                        self.view.changeDataAction(state: .failure(0))
                    }
                } error: { _ in }
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
