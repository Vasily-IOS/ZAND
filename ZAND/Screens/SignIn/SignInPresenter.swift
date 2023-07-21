//
//  SignInPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

protocol SignInPresenterOutput: AnyObject {
    var registerModel: RegisterModel { get set }
    var codeAreSuccessfullySended: Bool { get set  }

    func enterNamePhone()
    func enterSmsCode()
}

protocol SignInViewInput: AnyObject {
    func showAlert(type: AlertType)
    func dismiss()
    func updateUI(state: RegisterViewState)
}

enum AlertType {
    case enterYourName
    case phoneNumberLessThanEleven
    case codeIsInvalid
    case enterYourCode

    var textValue: String {
        switch self {
        case .enterYourName:
            return AssetString.enterYourName
        case .phoneNumberLessThanEleven:
            return AssetString.phoneNumberLessThanEleven
        case .codeIsInvalid:
            return AssetString.codeIsInvalid
        case .enterYourCode:
            return AssetString.enterYourCode
        }
    }
}

enum RegisterViewState {
    case sendCode
    case showProfile
}

final class SignInPresenter: SignInPresenterOutput {

    // MARK: - Properties

    weak var view: SignInViewInput?

    var registerModel = RegisterModel()

    var codeAreSuccessfullySended: Bool = false

    // MARK: - Initiailers

    init(view: SignInViewInput) {
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
