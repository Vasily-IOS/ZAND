//
//  ResetPasswordPresenter.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

import Foundation

protocol ResetPasswordViewInput: AnyObject {

}

protocol ResetPasswordOutput: AnyObject {
    var view: ResetPasswordViewInput { get }
}


final class ResetPasswordPresenter: ResetPasswordOutput {

    // MARK: - Properties

    unowned let view: ResetPasswordViewInput

    // MARK: - Initializers

    init(view: ResetPasswordViewInput) {
        self.view = view
    }
}
