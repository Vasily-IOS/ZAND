//
//  SignInPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

protocol SignInPresenterOutput: AnyObject {
    var signInModel: SignInModel { get set }
    var codeAreSuccessfullySended: Bool { get set }
    var keyboardAlreadyHidined: Bool { get set }

    func enterNamePhone()
    func enterSmsCode()
}

protocol SignInViewInput: AnyObject {
    func showAlert(type: AlertType, message: String?)
    func dismiss()
    func updateUI(state: RegisterViewState)
    func showIndicatorView() 
}

enum RegisterViewState {
    case sendCode
    case showProfile
    case backToTop
}

final class SignInPresenter: SignInPresenterOutput {

    // MARK: - Properties

    weak var view: SignInViewInput?

    var signInModel = SignInModel()

    var codeAreSuccessfullySended: Bool = false

    var keyboardAlreadyHidined: Bool = false

    // MARK: - Initiailers

    init(view: SignInViewInput) {
        self.view = view

        subscribeNotification()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Action

    @objc
    private func showIndicatorView() {
        view?.showIndicatorView()
    }

    // MARK: - Instance methods

    func enterNamePhone() {
        if signInModel.name.isEmpty {
            view?.showAlert(type: .enterYourName, message: nil)
        } else if signInModel.phone.count < 11 {
            view?.showAlert(type: .phoneNumberLessThanEleven, message: nil)
        } else {
            AGСConnectManagerImpl.shared.sendVerifyCode(
                name: signInModel.name,
                phoneNumber: signInModel.phone) { [weak self] success in
                    guard let self else {
                        self?.view?.updateUI(state: .backToTop)
                        self?.view?.showAlert(type: .gotError, message: AssetString.tryAgain)
                        return
                    }

                    self.codeAreSuccessfullySended = true
                    self.view?.updateUI(state: .sendCode)
                }

//            AuthManagerImpl.shared.startAuth(name: signInModel.name, phone: signInModel.phone)
//            { [weak self] success in
//                guard success,
//                let self else {
//                    self?.view?.updateUI(state: .backToTop)
//                    self?.view?.showAlert(type: .gotError, message: AssetString.tryAgain)
//                    return
//                }
//
//                self.codeAreSuccessfullySended = true
//                self.view?.updateUI(state: .sendCode)
//            }
        }
    }

    func enterSmsCode() {
        if signInModel.verifyCode.isEmpty {
            view?.showAlert(type: .enterYourCode, message: nil)
        } else {
            AGСConnectManagerImpl.shared.signIn(code: signInModel.verifyCode) { [weak self] success in
                guard success else {
                    self?.view?.updateUI(state: .backToTop)
                    self?.view?.showAlert(type: .gotError, message: AssetString.tryAgain)
                    return
                }

                self?.view?.updateUI(state: .showProfile)
            }

//            AuthManagerImpl.shared.verifyCode(code: signInModel.verifyCode) { [weak self] success in
//                guard success else {
//                    self?.view?.updateUI(state: .backToTop)
//                    self?.view?.showAlert(type: .gotError, message: AssetString.tryAgain)
//                    return
//                }
//
//                self?.view?.updateUI(state: .showProfile)
//            }
        }
    }

    private func subscribeNotification() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(showIndicatorView), name: .showIndicator, object: nil
        )
    }
}
