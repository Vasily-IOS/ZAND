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

    // MARK: - Lifecycle

    deinit {
        print("ConfirmationViewController died")
    }

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
        presenter?.createRecord()
    }
}

extension ConfirmationViewController: ConfirmationInput {

    // MARK: - ConfirmationInput methods

    func configure(viewModel: ConfirmationViewModel) {
        contentView.configure(viewModel: viewModel)
    }

    func showEntryConfirmedUI(isSuccess: Bool) {
        contentView.addSubview(contentView.entryConfirmedView)
        contentView.entryConfirmedView.configure(isSuccess: isSuccess)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.navigationController?.dismiss(animated: true)
        }
    }
}
