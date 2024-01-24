//
//  VerifyPresenter.swift
//  ZAND
//
//  Created by Василий on 26.12.2023.
//

import Foundation

enum VerifyType {
    case changeEmail
    case none
}

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

    var verifyType: VerifyType?

    unowned let view: VerifyInput

    private let network: ZandAppAPI

    // MARK: - Initializers

    init(view: VerifyInput, network: ZandAppAPI, verifyType: VerifyType?=nil) {
        self.view = view
        self.network = network
        self.verifyType = verifyType
    }

    // MARK: - Instance methods

    func verify(code: String) {
        network.performRequest(
            type: .verify(VerifyModel(verifyCode: code)),
            expectation: DefaultType.self
        ) { [weak self] _, isSuccess in
            guard let self else { return }

            if isSuccess {
                if (self.verifyType ?? .none) == .changeEmail {
                    self.view.popToRoot()
                    NotificationCenter.default.post(name: .signOut, object: nil)
                } else {
                    self.view.popToRoot()
                }
            } else {
                self.view.showAlert()
            }
        } error: { _ in }
    }
}
