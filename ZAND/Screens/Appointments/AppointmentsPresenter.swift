//
//  AppointmentsPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

enum AppointmentType {
    case past
    case upcoming
}

protocol AppointmentsPresenterOutput: AnyObject {
    func getData(by type: AppointmentType)
}

protocol AppointmentsInput: AnyObject {
    func updateUI(model: [AppointmentsModel])
}

final class AppointmentsPresenterImpl: AppointmentsPresenterOutput {

    // MARK: - Properties

    weak var view: AppointmentsInput?

    private let model = AppointmentsModel.model

    // MARK: - Initializers

    init(view: AppointmentsInput) {
        self.view = view
    }

    func getData(by type: AppointmentType) {
        switch type {
        case .upcoming:
            self.view?.updateUI(model: model.filter({ $0.isServiceIsDelivered == false }))
        case .past:
            self.view?.updateUI(model: model.filter({ $0.isServiceIsDelivered == true }))
        }
    }
}
