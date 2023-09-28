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
        contentView.staffComponentView.configure(model: viewModel.employeeCommon)
        contentView.nameComponentView.configure(
            topText: "Имя",
            bottomText: viewModel.fullName
        )
        contentView.phoneComponentView.configure(
            topText: "Телефон",
            bottomText: viewModel.phone
        )
        contentView.serviceComponentView.configure(
            topText: viewModel.bookService?.title ?? "",
            bottomText: "\(viewModel.bookService?.price_max ?? 0) руб."
        )

        contentView.dateComponentView.configure(
            topText: viewModel.startSeanceDate ?? "",
            bottomText: viewModel.startSeanceTime ?? ""
        )
    }
}
