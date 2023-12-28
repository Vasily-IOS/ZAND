//
//  AppleSignInViewController.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import UIKit

final class SignInViewController: BaseViewController<SignInView> {

    // MARK: - Properties

    var presenter: SignInPresenter?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegates()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    // MARK: - Instance methods

    private func subscribeDelegates() {
        contentView.delegate = self
    }
}

extension SignInViewController: SignInDelegate {

    // MARK: - AppleSignInDelegate methods

    func signInButtonTap() {
        presenter?.signIn()
    }

    func forgotButtonDidTap() {
        AppRouter.shared.push(.resetPassword)
    }

    func registerButtonDidTap() {
        AppRouter.shared.push(.register)
    }

    func cancelEditing() {
        contentView.endEditing(true)
    }

    func setEmail(text: String) {
        presenter?.email = text
    }

    func setLogin(text: String) {
        presenter?.password = text
    }

    func showEmptyFieldsAlert() {
        AppRouter.shared.showAlert(type: .fillAllRequiredFields, message: nil)
    }

    func showBadInputAlert() {
        AppRouter.shared.showAlert(type: .invalidEmailOrPassword, message: nil)
    }
}

extension SignInViewController: SignInViewInput {

    // MARK: - SignInViewInput methods

    func switchScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            AppRouter.shared.switchRoot(type: .profile)
        }
    }
}
