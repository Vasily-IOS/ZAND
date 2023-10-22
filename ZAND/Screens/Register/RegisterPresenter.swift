//
//  RegisterNPresenter.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import Foundation

protocol RegisterPresenterOutput: AnyObject {
    var keyboardAlreadyHidined: Bool { get set }
    var user: User { get set }
    func save()
}

protocol RegisterViewInput: AnyObject {
    func configure(model: User)
}

final class RegisterPresenter: RegisterPresenterOutput {

    // MARK: - Properties

    weak var view: RegisterViewInput?

    var user: User

    var keyboardAlreadyHidined: Bool = false

    // MARK: - Initializers

    init(view: RegisterViewInput, user: User) {
        self.view = view
        self.user = user

        view.configure(model: user)
    }

    // MARK: - Instance methods

    func save() {
        UserDBManager.shared.save(user: user)
    }
}
