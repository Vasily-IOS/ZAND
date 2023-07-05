//
//  RegisterPresenter.swift
//  ZAND
//
//  Created by Василий on 07.06.2023.
//

import Foundation

protocol RegisterPresenterOutput: AnyObject {
    func setInitialState()
    func performUpdateUI(to state: RegistrationState)
}

protocol RegisterViewInput: AnyObject {
    func setInitialState(state: RegistrationState)
    func updateUI(by state: RegistrationState)
}

enum RegistrationState {
    case firstStep
    case secondStep
    case thirdStep
}

final class RegisterPresenter: RegisterPresenterOutput {

    // MARK: - Instance methods

    weak var view: RegisterViewInput?

    // MARK: - Initializers

    init(view: RegisterViewInput) {
        self.view = view
    }

    // MARK: - Instance properties

    func performUpdateUI(to state: RegistrationState) {
        view?.updateUI(by: state)
    }

    func setInitialState() {
        view?.setInitialState(state: .firstStep)
    }
}
