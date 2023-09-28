//
//  ConfirmationPresenter.swift
//  ZAND
//
//  Created by Василий on 28.09.2023.
//

import Foundation

protocol ConfirmationOutput: AnyObject {
    var viewModel: ConfirmationViewModel { get }
//    var seanceDate: String? { get set }
//    var seanceTime: String? { get set }
    func createRecord()
    func updateUI()
}

protocol ConfirmationInput: AnyObject {
    func configure(viewModel: ConfirmationViewModel)
}

final class ConfirmationPresenter: ConfirmationOutput {

    // MARK: - Properties

    weak var view: ConfirmationInput?

//    var seanceDate: String?
//
//    var seanceTime: String?

    var viewModel: ConfirmationViewModel

    private let network: HTTP

    // MARK: - Initializers

    init(view: ConfirmationInput, viewModel: ConfirmationViewModel, network: HTTP) {
        self.view = view
        self.viewModel = viewModel
        self.network = network

        self.updateUI()
//        self.fetchDateViewComponents()
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
        }
    }

//    func fetchDateViewComponents() {
//        let date = try? Date(viewModel.bookTime?.datetime ?? "", strategy: .iso8601)
//        let formatter = DateFormatter()
//        formatter.dateStyle = .long
//        formatter.locale = Locale(identifier: "ru_RU")
//        let seanceLength = "\((viewModel.bookTime?.seance_length ?? 0)/60) мин."
//        let seanceFullData = (viewModel.bookTime?.time ?? "") + " " + seanceLength
//
//        seanceDate = formatter.string(from: date ?? Date())
//        seanceTime = seanceFullData
//    }
}
