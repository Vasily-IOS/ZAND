//
//  RefreshPasswordViewController.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

import UIKit

final class RefreshPasswordViewController: BaseViewController<RefreshPasswordView> {

    // MARK: - Properties

    var presenter: RefreshPasswordPresenter?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        subscribeDelegates()
    }

    // MARK: - Instance methods

    private func subscribeDelegates() {
        contentView.delegate = self
    }
}

extension RefreshPasswordViewController: RefreshPasswordDelegate {

    // MARK: - RefreshPasswordDelegate methods

    func refreshButtonDidTap() {
        presenter?.refreshPassword()
    }

    func cancelEditing() {
        contentView.endEditing(true)
    }

    func setPassword(text: String) {
        presenter?.password = text
    }

    func setRepeatPassword(text: String) {
        presenter?.repeatPassword = text
    }

    func setVerifyCode(text: String) {
        presenter?.verifyCode = text
    }
}

extension RefreshPasswordViewController: RefreshPasswordInput {

    // MARK: - RefreshPasswordInput

    func popToRoot() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            AppRouter.shared.popToRoot()
        }
    }

    func showAllFieldsFilledAlert() {
        AppRouter.shared.showAlert(type: .fillAllRequiredFields, message: nil)
    }

    func showPassInNotEqualAlert() {
        AppRouter.shared.showAlert(type: .passwwordsIsNotEqual, message: nil)
    }

    func showPassCountLessThenEightAlert() {
        AppRouter.shared.showAlert(type: .passwordCountIsSmall, message: nil)
    }

    func showSmthWentWrongAlert() {
        AppRouter.shared.showAlert(type: .smthWentWrong, message: nil)
    }
}
