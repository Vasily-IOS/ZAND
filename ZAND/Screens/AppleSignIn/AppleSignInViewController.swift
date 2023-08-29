//
//  AppleSignInViewController.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import UIKit
import AuthenticationServices

final class AppleSignInViewController: BaseViewController<AppleSignInView> {

    // MARK: - Properties

    var presenter: AppleSignInPresenter?

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

extension AppleSignInViewController: AppleSignInDelegate {

    // MARK: - AppleSignInDelegate methods

    func signInButtonTap() {
        presenter?.createAuthRequest()
    }
}

extension AppleSignInViewController: AppleSignInViewInput {

    // MARK: - AppleSignInViewInput methods
    
    func showASAuthController(request: ASAuthorizationOpenIDRequest) {
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self

        controller.performRequests()
    }
}

extension AppleSignInViewController: ASAuthorizationControllerDelegate {

    // MARK: - ASAuthorizationControllerDelegate methods

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credential as ASAuthorizationAppleIDCredential:
            let user = User(credential: credential)

            AppRouter.shared.push(.registerN(user))
        default:
            break
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        debugPrint(error)
    }
}

extension AppleSignInViewController: ASAuthorizationControllerPresentationContextProviding {

    // MARK: - ASAuthorizationControllerPresentationContextProviding methods

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}
