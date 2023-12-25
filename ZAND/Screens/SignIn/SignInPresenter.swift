//
//  AppleSignInPresenter.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import Foundation

protocol SignInPresenterOutput: AnyObject {
    
}

protocol SignInViewInput: AnyObject {

}

final class SignInPresenter: SignInPresenterOutput {

    // MARK: - Properties

    unowned let view: SignInViewInput

    // MARK: - Initializers

    init(view: SignInViewInput) {
        self.view = view
    }

    // MARK: - Instance methods


}
