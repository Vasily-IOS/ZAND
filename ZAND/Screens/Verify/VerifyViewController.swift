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
        if let code = contentView.confirmationCodeTextField.text?.trimmingCharacters(in: .whitespaces) {
            presenter?.verify(code: code)
        }
    }

    func cancelEditing() {
        contentView.endEditing(true)
    }
}

extension VerifyViewController: VerifyInput {

    // MARK: - VerifyInput methods

    func popToRoot() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }

    func showAlert() {
        AppRouter.shared.showAlert(type: .codeIsInvalid, message: nil)
    }
}
