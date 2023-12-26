//
//  ResetPassword.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

import UIKit

final class ResetPasswordViewController: BaseViewController<ResetPasswordView> {

    // MARK: - Properties

    var presenter: ResetPasswordOutput?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegates()
        navigationController?.setNavigationBarHidden(false, animated: true)
        hideBackButtonTitle()
    }

    // MARK: - Instance methods

    private func subscribeDelegates() {
        contentView.delegate = self
    }

}

extension ResetPasswordViewController: ResetPasswordDelegate {

    // MARK: - ResetPasswordDelegate methods

    func sendButtonDidTap() {
        AppRouter.shared.push(.refreshPassword)
    }
}

extension ResetPasswordViewController: ResetPasswordViewInput {
    
}

extension ResetPasswordViewController: HideBackButtonTitle {}
