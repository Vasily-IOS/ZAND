//
//  AppleSignInViewController.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import UIKit
import AuthenticationServices

final class SignInViewController: BaseViewController<SignInView> {

    // MARK: - Properties

    var presenter: SignInPresenter?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegates()
    }

    // MARK: - Instance methods

    private func subscribeDelegates() {
        contentView.delegate = self
    }
}

extension SignInViewController: SignInDelegate {

    // MARK: - AppleSignInDelegate methods

    func signInButtonTap() {
        print("Enter")
    }

    func forgotButtonDidTap() {
        AppRouter.shared.push(.resetPassword)
    }

    func registerButtonDidTap() {
        AppRouter.shared.push(.register)
    }
}

extension SignInViewController: SignInViewInput {

    // MARK: - SignInViewInput methods

}
