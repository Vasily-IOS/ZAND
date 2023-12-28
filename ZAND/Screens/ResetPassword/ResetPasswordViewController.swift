//
//  ResetPassword.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

import UIKit

final class ResetPasswordViewController: BaseViewController<ResetPasswordView> {

    // MARK: - Properties

    var presenter: ResetPasswordOutput?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegates()
        hideBackButtonTitle()
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Instance methods

    private func subscribeDelegates() {
        contentView.delegate = self
    }
}

extension ResetPasswordViewController: ResetPasswordDelegate {

    // MARK: - ResetPasswordDelegate methods

    func resetPasswordButtonDidTap() {
        presenter?.resetPassword()
    }

    func cancelEditing() {
        contentView.endEditing(true)
    }

    func setEmail(text: String) {
        presenter?.email = text
    }
}

extension ResetPasswordViewController: ResetPasswordViewInput {

    // MARK: - ResetPasswordViewInput methods

    func showRefreshPasswordScreen() {
        AppRouter.shared.push(.refreshPassword)
    }

    func showAlert() {
        AppRouter.shared.showAlert(type: .smthWentWrong, message: nil)
    }
}

extension ResetPasswordViewController: HideBackButtonTitle {}
