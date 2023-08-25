//
//  RegisterPresenter.swift
//  ZAND
//
//  Created by Василий on 07.06.2023.
//

import Foundation

struct RegisterModel {
    var phone: String = ""
    var verifyCode: String = ""
}

protocol RegisterPresenterOutput: AnyObject {
    var registerModel: RegisterModel { get set }
    var codeAreSuccessfullySended: Bool { get set }
    var keyboardAlreadyHidined: Bool { get set }

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

    var keyboardAlreadyHidined: Bool = false

    // MARK: - Initializers

    init(view: RegisterViewInput) {
        self.view = view
    }

    // MARK: - Instance methods

    func enterNamePhone() {
        if registerModel.phone.isEmpty {
            view?.showAlert(type: .enterPhone)
        } else if registerModel.phone.count < 10 {
            view?.showAlert(type: .phoneNumberLessThanEleven)
        } else {
            AGConnectManagerImpl.shared.sendVerifyCode(
                phoneNumber: registerModel.phone
            ) { [weak self] success in
                guard let self, success else { return }

                self.codeAreSuccessfullySended = true
                self.view?.updateUI(state: .sendCode)
            }
        }
    }

    func enterSmsCode() {
        if registerModel.verifyCode.isEmpty {
            view?.showAlert(type: .enterYourCode)
        } else {
            AGConnectManagerImpl.shared.createUser(
                phoneNumber: registerModel.phone,
                verifyCode: registerModel.verifyCode
            ) { [weak self] success in
                guard let self, success else { return }

                self.view?.updateUI(state: .showProfile)
            }
        }
    }
}
