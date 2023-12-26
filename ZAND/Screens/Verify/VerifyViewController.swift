//
//  VerifyViewController.swift
//  ZAND
//
//  Created by Василий on 26.12.2023.
//

import UIKit

final class VerifyViewController: BaseViewController<VerifyView> {

    // MARK: - Properties

    var presenter: VerifyPresenter?

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

extension VerifyViewController: VerifyViewDelegate {

    // MARK: - VerifyViewDelegate methods

    func sendButtonDidTap() {
        guard let code = contentView.confirmationCodeTextField.text?.trimmingCharacters(in: .whitespaces) else { return }

        presenter?.verify(code: code)
    }
}

extension VerifyViewController: VerifyInput {}
