//
//  SignInPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

protocol SignInPresenterOutput: AnyObject {
    var email: String { get set }
    var password: String { get set }

    func signIn()
}

protocol SignInViewInput: AnyObject {
    func signInSuccess()
}

final class SignInPresenter: SignInPresenterOutput {

    // MARK: - Properties

    weak var view: SignInViewInput?

    var email: String = ""

    var password: String = ""

    // MARK: - Initiailers

    init(view: SignInViewInput) {
        self.view = view
    }

    func signIn() {
        AuthManagerImpl.shared.signIn(email: email, password: password) { [weak self] result in
            if result == true {
                self?.view?.signInSuccess()
            }
        }
    }
}
