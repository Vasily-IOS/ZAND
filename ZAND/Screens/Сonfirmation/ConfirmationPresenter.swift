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

    private let network: APIManagerCommonP

    private let realm: RealmManager

    // MARK: - Initializers

    init(
        view: ConfirmationInput,
        viewModel: ConfirmationViewModel,
        network: APIManagerCommonP,
        realm: RealmManager
    ) {
        self.view = view
        self.viewModel = viewModel
        self.network = network
        self.realm = realm
        
        self.updateUI()
        self.suscribeNotifications()

        viewModel.build()
    }

    deinit {
        print("ConfirmationPresenter died")
    }

    // MARK: - Instance methods

    @objc
    private func showBadRequestUI() {
        view?.showEntryConfirmedUI(isSuccess: false)
    }

    func updateUI() {
        view?.configure(viewModel: viewModel)
    }

    func createRecord() {
        guard let model = viewModel.resultModel else { return }

        network.performRequest(
            type: .createRecord(
            company_id: viewModel.company_id,
            model: model), expectation: RecordCreatedModel.self)
        { [weak self] result in
            guard let self else { return }

            // save record info
            let dataBaseModel = RecordDataBaseModel()
            dataBaseModel.company_id = String(self.viewModel.company_id)
            dataBaseModel.company_name = viewModel.companyName
            dataBaseModel.company_address = viewModel.companyAddress
            dataBaseModel.record_id = String(result.data.first?.record_id ?? 0)
            realm.save(object: dataBaseModel)

            self.view?.showEntryConfirmedUI(isSuccess: result.success)
        }
    }

    private func suscribeNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(showBadRequestUI),
            name: .showBadRequestScreen,
            object: nil
        )
    }
}
