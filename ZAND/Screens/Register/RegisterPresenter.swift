//
//  RegisterPresenter.swift
//  ZAND
//
//  Created by Василий on 07.06.2023.
//

import Foundation

protocol RegisterPresenterOutput: AnyObject {
    var registerModel: RegisterModel { get set }
    var codeAreSuccessfullySended: Bool { get set  }

    func enterNamePhone()
    func enterSmsCode()
}

protocol RegisterViewInput: AnyObject {
    func showAlert(type: AlertType)
    func dismiss()

    func updateUI(state: RegisterViewState)
}

final class RegisterPresenter: RegisterPresenterOutput {

    // MARK: - Properties

    weak var view: RegisterViewInput?
    var registerModel = RegisterModel()
    var codeAreSuccessfullySended: Bool = false

    // MARK: - Initializers

    init(view: RegisterViewInput) {
        self.view = view
    }

    // MARK: - Instance methods

    func enterNamePhone() {
        if registerModel.name.isEmpty {
            view?.showAlert(type: .enterYourName)
        } else if registerModel.phone.count < 11 {
            view?.showAlert(type: .phoneNumberLessThanEleven)
        } else {
            AuthManagerImpl.shared.startAuth(name: registerModel.name, phone: registerModel.phone)
            { [weak self] success in
                guard success else { return }

                self?.codeAreSuccessfullySended = true
                self?.view?.updateUI(state: .sendCode)
            }
        }
    }

    func enterSmsCode() {
        if registerModel.verifyCode.isEmpty {
            view?.showAlert(type: .enterYourCode)
        } else {
            AuthManagerImpl.shared.verifyCode(code: registerModel.verifyCode) { [weak self] success in
                guard success else { return }

                self?.view?.updateUI(state: .showProfile)
            }
        }
    }
}
