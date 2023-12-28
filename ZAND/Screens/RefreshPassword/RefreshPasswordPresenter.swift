//
//  RefreshPasswordPresenter.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

import Foundation

protocol RefreshPasswordInput: AnyObject {
    func popToRoot()
    func showAllFieldsFilledAlert()
    func showPassInNotEqualAlert()
    func showPassCountLessThenEightAlert()
    func showSmthWentWrongAlert()
}

protocol RefreshPasswordOutput: AnyObject {
    var view: RefreshPasswordInput { get }

    var password: String { get set }
    var repeatPassword: String { get set }
    var verifyCode: String { get set }

    func refreshPassword()
}

final class RefreshPasswordPresenter: RefreshPasswordOutput {

    // MARK: - Properties

    var password = ""

    var repeatPassword = ""

    var verifyCode = ""

    var allFieldsFilled: Bool {
        return !password.isEmpty && !repeatPassword.isEmpty && !verifyCode.isEmpty
    }

    var passIsEqual: Bool {
        return password == repeatPassword
    }

    var passCountLessEightSymbols: Bool {
        return password.count >= 8 && repeatPassword.count >= 8
    }

    unowned let view: RefreshPasswordInput

    private let network: APIManagerAuthP

    // MARK: - Initializers

    init(view: RefreshPasswordInput, network: APIManagerAuthP) {
        self.view = view
        self.network = network
    }

    // MARK: - Instance methods

    func refreshPassword() {
        if !allFieldsFilled {
            view.showAllFieldsFilledAlert()
        } else if !passIsEqual {
            view.showPassInNotEqualAlert()
        } else if !passCountLessEightSymbols {
            view.showPassCountLessThenEightAlert()
        } else {
            network.performRequest(
                type: .refreshPassword(NewPassword(verifyCode: verifyCode, password: password)),
                expectation: DefaultType.self
            ) { [weak self] _, isSucceess in
                guard let self else { return }

                isSucceess ? view.popToRoot() : view.showSmthWentWrongAlert()
            }
        }
    }
}
