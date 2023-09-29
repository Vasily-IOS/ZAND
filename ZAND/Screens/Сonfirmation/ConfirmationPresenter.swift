//
//  ConfirmationPresenter.swift
//  ZAND
//
//  Created by Василий on 28.09.2023.
//

import Foundation

protocol ConfirmationOutput: AnyObject {
    var viewModel: ConfirmationViewModel { get }
    func createRecord()
    func updateUI()
}

protocol ConfirmationInput: AnyObject {
    func configure(viewModel: ConfirmationViewModel)
    func showEntryConfirmedUI(isSuccess: Bool)
}

final class ConfirmationPresenter: ConfirmationOutput {

    // MARK: - Properties

    weak var view: ConfirmationInput?

    var viewModel: ConfirmationViewModel

    private let network: HTTP

    // MARK: - Initializers

    init(view: ConfirmationInput, viewModel: ConfirmationViewModel, network: HTTP) {
        self.view = view
        self.viewModel = viewModel
        self.network = network

        self.updateUI()
    }

    deinit {
        print("ConfirmationPresenter died")
    }

    // MARK: - Instance methods

    func updateUI() {
        view?.configure(viewModel: viewModel)
    }

    func createRecord() {
        guard let model = viewModel.resultModel else { return }

        network.performRequest(
            type: .createRecord(
            company_id: viewModel.company_id,
            model: model), expectation: RecordCreatedModel.self)
        { result in
            print(result)
            self.view?.showEntryConfirmedUI(isSuccess: result.success)
        }
    }
}
