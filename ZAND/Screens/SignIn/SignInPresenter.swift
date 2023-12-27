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

    func login()
}

protocol SignInViewInput: AnyObject {
    func showAlert()
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

    func login() {
        guard !email.isEmpty && !password.isEmpty else {
            view.showAlert()
            return
        }
        let model = LoginModel(email: email, password: password)
        network.performRequest(type: .login(model), expectation: UpdatedTokenModel.self
        ) { [weak self] result in
            let tokenModel = TokenModel(
                accessToken: result.data.token,
                refreshToken: result.data.refreshToken,
                savedDate: Date()
            )
            TokenManager.shared.save(tokenModel)
            self?.fetchAndSaveUser()
            self?.view.switchScreen()
        }
    }

    func fetchAndSaveUser() {
        network.performRequest(type: .getUser, expectation: UserModel.self) { user in
            UserDBManager.shared.save(
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
