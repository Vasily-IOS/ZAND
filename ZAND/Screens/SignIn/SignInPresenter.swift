//
//  AppleSignInPresenter.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import Foundation
import AuthenticationServices

protocol SignInPresenterOutput: AnyObject {
    func createAuthRequest()
}

protocol SignInViewInput: AnyObject {
    func showASAuthController(request: ASAuthorizationOpenIDRequest)
}

final class SignInPresenter: SignInPresenterOutput {

    // MARK: - Properties

    weak var view: SignInViewInput?

    // MARK: - Initializers

    init(view: SignInViewInput) {
        self.view = view
    }

    // MARK: - Instance methods

    func createAuthRequest() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email, .fullName]

        view?.showASAuthController(request: request)
    }
}
