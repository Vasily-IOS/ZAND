//
//  ResetPasswordPresenter.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

import Foundation

protocol ResetPasswordViewInput: AnyObject {
    func showRefreshPasswordScreen()
    func showSmthWentWrongAlert()
    func showFillEmailAlert()
}

protocol ResetPasswordOutput: AnyObject {
    var view: ResetPasswordViewInput { get }
    var email: String { get set }
    
    func resetPassword()
}


final class ResetPasswordPresenter: ResetPasswordOutput {

    // MARK: - Properties

    var email: String = ""

    unowned let view: ResetPasswordViewInput

    private let network: ZandAppAPI

    // MARK: - Initializers

    init(view: ResetPasswordViewInput, network: ZandAppAPI) {
        self.view = view
        self.network = network
    }

    // MARK: - Instance methods

    func resetPassword() {
        guard !email.isEmpty else {
            view.showFillEmailAlert()
            return
        }

        network.performRequest(
            type: .resetPassword(EmailModel(email: email)),
            expectation: DefaultType.self
        ) { [weak self] _, isSuccess in
            guard let self else { return }

            isSuccess ? self.view.showRefreshPasswordScreen() : self.view.showSmthWentWrongAlert()
        } error: { _ in }
    }
}
