//
//  AppleSignInPresenter.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import Foundation

protocol SignInPresenterOutput: AnyObject {
    var email: String { get set }
    var password: String { get set }

    func checkUndeletableInfo()
    func signIn()
}

protocol SignInViewInput: AnyObject {
    func showEmptyFieldsAlert()
    func showBadInputAlert()
    func switchScreen()
    func setupUndeletableUser(user: UndeletableUserModel)
}

final class SignInPresenter: SignInPresenterOutput {

    // MARK: - Properties

    var email: String = ""

    var password: String = ""

    unowned let view: SignInViewInput

    private let network: ZandAppAPI

    // MARK: - Initializers

    init(view: SignInViewInput, network: ZandAppAPI) {
        self.view = view
        self.network = network
    }

    // MARK: - Instance methods

    func checkUndeletableInfo() {
        guard let user = fetchUndeletableUser() else { return }

        email = user.email
        password = user.password

        view.setupUndeletableUser(user: user)
    }

    func signIn() {
        guard !email.isEmpty && !password.isEmpty else {
            view.showEmptyFieldsAlert()
            return
        }

        let model = LoginModel(email: email, password: password)
        network.performRequest(type: .login(model), expectation: UpdatedTokenModel.self
        ) { [weak self] result, isSuccess in
            guard let self else { return }

            if isSuccess {
                if let updatedModel = result {
                    let tokenModel = TokenModel(
                        accessToken: updatedModel.data.token,
                        refreshToken: updatedModel.data.refreshToken,
                        savedDate: Date()
                    )
                    TokenManager.shared.save(tokenModel)
                    self.fetchAndSaveUser()
                    self.saveUndeletableUserData()
                    self.view.switchScreen()
                }
            } else {
                self.view.showBadInputAlert()
            }
        } error: { _ in }
    }

    func fetchAndSaveUser() {
        network.performRequest(
            type: .getUser,
            expectation: UserModel.self
        ) { user, isSuccess in
            guard let user = user, isSuccess else { return }

            UserManager.shared.save(
                user: UserModel(data: User(
                    lastName: user.data.lastName,
                    middleName: user.data.middleName,
                    firstName: user.data.firstName,
                    email: user.data.email,
                    phone: user.data.phone,
                    birthday: user.data.birthday)
                )
            )
        } error: { _ in }
    }

    private func saveUndeletableUserData() {
        let undeletableUserModel = UndeletableUserModel(email: email, password: password)
        let data = try! JSONEncoder().encode(undeletableUserModel)
        UserDefaults.standard.set(data, forKey: Config.undeletableUserKey)
    }

    private func fetchUndeletableUser() -> UndeletableUserModel? {
        let data = UserDefaults.standard.data(forKey: Config.undeletableUserKey)
        do {
           return try JSONDecoder().decode(UndeletableUserModel.self, from: data ?? Data())
        } catch let error {
            debugPrint(error)
            return nil
        }
    }
}
