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

    func signIn()
}

protocol SignInViewInput: AnyObject {
    func showEmptyFieldsAlert()
    func showBadInputAlert()
    func switchScreen()
}

final class SignInPresenter: SignInPresenterOutput {

    // MARK: - Properties

    var email: String = ""

    var password: String = ""

    unowned let view: SignInViewInput

    private let network: APIManagerAuthP

    // MARK: - Initializers

    init(view: SignInViewInput, network: APIManagerAuthP) {
        self.view = view
        self.network = network
    }

    // MARK: - Instance methods

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
                    self.view.switchScreen()
                }
            } else {
                self.view.showBadInputAlert()
            }
        }
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
        }
    }
}
