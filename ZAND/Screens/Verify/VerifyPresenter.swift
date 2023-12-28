//
//  VerifyPresenter.swift
//  ZAND
//
//  Created by Василий on 26.12.2023.
//

import Foundation

protocol VerifyOutput: AnyObject {
    var view: VerifyInput { get }

    func verify(code: String)
}

protocol VerifyInput: AnyObject {
    func popToRoot()
    func showAlert()
}

final class VerifyPresenter: VerifyOutput {

    // MARK: - Properties

    unowned let view: VerifyInput

    private let network: APIManagerAuthP

    // MARK: - Initializers

    init(view: VerifyInput, network: APIManagerAuthP) {
        self.view = view
        self.network = network
    }

    // MARK: - Instance methods

    func verify(code: String) {
        network.performRequest(
            type: .verify(VerifyModel(verifyCode: code)),
            expectation: DefaultType.self
        ) { [weak self] _, isSuccess in
            isSuccess ? self?.view.popToRoot() : self?.view.showAlert()
        }
    }
}
