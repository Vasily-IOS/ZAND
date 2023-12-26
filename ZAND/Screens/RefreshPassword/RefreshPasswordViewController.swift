//
//  RefreshPasswordViewController.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

import UIKit

final class RefreshPasswordViewController: BaseViewController<RefreshPasswordView> {

    // MARK: - Properties

    var presenter: RefreshPasswordPresenter?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(false, animated: true)
        subscribeDelegates()
    }

    // MARK: - Instance methods

    private func subscribeDelegates() {
        contentView.delegate = self
    }
}

extension RefreshPasswordViewController: RefreshPasswordDelegate {

    // MARK: - RefreshPasswordDelegate methods

    func refreshButtonDidTap() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            AppRouter.shared.popToRoot()
        }
    }
}

extension RefreshPasswordViewController: RefreshPasswordInput {

}

