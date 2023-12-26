//
//  VerifyPresenter.swift
//  ZAND
//
//  Created by Василий on 26.12.2023.
//

import Foundation

protocol VerifyOutput: AnyObject {
    var view: VerifyInput { get }
}

protocol VerifyInput: AnyObject {

}

final class VerifyPresenter: VerifyOutput {

    // MARK: - Properties

    unowned let view: VerifyInput

    // MARK: - Initializers

    init(view: VerifyInput) {
        self.view = view
    }

}
