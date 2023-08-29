//
//  AppleSignInPresenter.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import Foundation
import AuthenticationServices

protocol AppleSignInPresenterOutput: AnyObject {
    func createAuthRequest()
}

protocol AppleSignInViewInput: AnyObject {
    func showASAuthController(request: ASAuthorizationOpenIDRequest)
}

final class AppleSignInPresenter: AppleSignInPresenterOutput {

    // MARK: - Properties

    weak var view: AppleSignInViewInput?

    // MARK: - Initializers

    init(view: AppleSignInViewInput) {
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
