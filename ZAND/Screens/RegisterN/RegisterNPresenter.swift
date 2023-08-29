//
//  RegisterNPresenter.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import Foundation

protocol RegisterNPresenterOutput: AnyObject {

}

protocol RegisterNViewInput: AnyObject {

}

final class RegisterNPresenter: RegisterNPresenterOutput {

    // MARK: - Properties

    weak var view: RegisterNViewInput?

    var user: User

    // MARK: - Initializers

    init(view: RegisterNViewInput, user: User) {
        self.view = view
        self.user = user

        print(user.id)
    }

    // MARK: - Instance methods

}
