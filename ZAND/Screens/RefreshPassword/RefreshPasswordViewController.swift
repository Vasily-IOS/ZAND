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
    }
}

extension RefreshPasswordViewController: RefreshPasswordInput {

}

