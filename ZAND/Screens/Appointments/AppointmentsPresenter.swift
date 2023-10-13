//
//  AppointmentsPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

enum AppointmentType {
    case waitingServices
    case servicesProvided
}

protocol AppointmentsPresenterOutput: AnyObject {
    var waitingServicesModel: [UIAppointmentModel] { get set }
    func getData(by type: AppointmentType)
}

protocol AppointmentsInput: AnyObject {
    func updateUI(model: [UIAppointmentModel])
    func showIndicator(_ isShow: Bool)
}

final class AppointmentsPresenterImpl: AppointmentsPresenterOutput {

    // MARK: - Properties

    weak var view: AppointmentsInput?

    var waitingServicesModel: [UIAppointmentModel] = [] {
        didSet {
            view?.showIndicator(false)
            view?.updateUI(model: waitingServicesModel)
        }
    }

    var servicesProvidedModel: [UIAppointmentModel] = []

    private let network: HTTP

    private let realm: RealmManager

    // MARK: - Initializers

    init(view: AppointmentsInput, network: HTTP, realm: RealmManager) {
        self.view = view
        self.network = network
        self.realm = realm

        self.performRequest(model: Array(realm.get(RecordDataBaseModel.self)))
    }

    func getData(by type: AppointmentType) {
        switch type {
        case .waitingServices:
            self.view?.updateUI(model: waitingServicesModel)
        case .servicesProvided:
            self.view?.updateUI(model: servicesProvidedModel)
        }
    }

    private func performRequest(model: [RecordDataBaseModel]) {
        view?.showIndicator(true)
        model.forEach { recordModel in
            network.performRequest(
                type: .getRecord(
                    company_id: Int(recordModel.company_id) ?? 0,
                    record_id: Int(recordModel.record_id) ?? 0), expectation: GetRecordModel.self
            ) { [weak self] result in
                self?.makeModel(result)
            }
        }
    }

    private func makeModel(_ getRecord: GetRecordModel) {
        if let dataBaseModel = Array(
            realm.get(RecordDataBaseModel.self)).first(where: { Int($0.record_id) == getRecord.data.id })
        {
            if getRecord.data.attendance == AttendanceID.waiting.rawValue {
                let uiModel = UIAppointmentModel(networkModel: getRecord.data, dataBaseModel: dataBaseModel)
                waitingServicesModel.append(uiModel)
            } else if getRecord.data.attendance == AttendanceID.serviceDelivered.rawValue {
                let uiModel = UIAppointmentModel(networkModel: getRecord.data, dataBaseModel: dataBaseModel)
                servicesProvidedModel.append(uiModel)
            }
        }
    }
}

//enum AttendanceID: Int {
//    case userDidNotCome = -1 // пользователь не пришел на визит
//    case waiting = 0 // ожидание пользователя
//    case serviceDelivered = 1 // услуги оказаны
//    case userConfirmed = 2 // пользователь подтвердил запись
//}
