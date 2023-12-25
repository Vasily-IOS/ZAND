//
//  RegisterNPresenter.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import Foundation

protocol RegisterPresenterOutput: AnyObject {
    var keyboardAlreadyHidined: Bool { get set }
//    var user: UserModel { get set }
    func save()
}

protocol RegisterViewInput: AnyObject {
    func configure(model: UserModel)
}

final class RegisterPresenter: RegisterPresenterOutput {

    // MARK: - Properties

    weak var view: RegisterViewInput?

//    var user: UserModel

    var keyboardAlreadyHidined: Bool = false

    // MARK: - Initializers

    init(view: RegisterViewInput) {
        self.view = view
//        self.user = user

//        view.configure(model: user)
    }

    // MARK: - Instance methods

    func save() {
//        UserDBManager.shared.save(user: user)
    }
}
