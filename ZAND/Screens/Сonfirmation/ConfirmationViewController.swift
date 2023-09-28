//
//  ConfirmationViewController.swift
//  ZAND
//
//  Created by Василий on 28.09.2023.
//

import UIKit

final class ConfirmationViewController: BaseViewController<ConfirmationView> {

    // MARK: - Properties

    var presenter: ConfirmationPresenter?

    // MARK: - Initializers

    // MARK: - Lifecycle

    // MARK: - Instance methods

    override func viewDidLoad() {
        super.viewDidLoad()

        title = AssetString.checkAppointment

        subscribeDelegates()
    }

    private func subscribeDelegates() {
        contentView.delegate = self
    }
}

extension ConfirmationViewController: ConfirmationViewDelegate {

    // MARK: - ConfirmationViewDelegate methods

    func confirm() {
        print(presenter?.viewModel.resultModel)
    }
}

extension ConfirmationViewController: ConfirmationInput {

    
}
