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
    func deleteAppointment(appointmentID: Int)
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

    private let network: APIManager

    private let realm: RealmManager

    // MARK: - Initializers

    init(view: AppointmentsInput, network: APIManager, realm: RealmManager) {
        self.view = view
        self.network = network
        self.realm = realm

        self.getDataSourceRequest()
    }

    // MARK: - Instance methods

    func getData(by type: AppointmentType) {
        DispatchQueue.main.async {
            switch type {
            case .waitingServices:
                self.view?.updateUI(model: self.waitingServicesModel)
            case .servicesProvided:
                self.view?.updateUI(model: self.servicesProvidedModel)
            }
        }
    }

    func deleteAppointment(appointmentID: Int) {
        let model = waitingServicesModel.first(where: { $0.id == appointmentID })
        let record_id = model?.id ?? 0
        let company_id = model?.company_id ?? 0

        let urlString = "https://api.yclients.com/api/v1/record/\(company_id)/\(record_id)"
        let headers: [String: String]? = [
            "Content-type": "application/json",
            "Accept": "application/vnd.api.v2+json",
            "Authorization": "Bearer fbast32fa6hp2j6wz8hg, User 983196026753a4a61b7a6c638cc7dea7"
        ]
        guard let url = URL(string: urlString) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = headers

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard error == nil else {
                print("Error in appointment deletion")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 204 {
                    // perform update models
                    DispatchQueue.main.async {
                        self?.getDataSourceRequest()
                    }
                }
                print("Response HTTP code: \(httpResponse.statusCode)")
            }
        }.resume()
    }

    private func getDataSourceRequest() {
        let model = Array(realm.get(RecordDataBaseModel.self))
        view?.showIndicator(true)

        let group = DispatchGroup()
        var waitingServiceSortedModel: [UIAppointmentModel] = []
        var servicesProvidedSortedModel: [UIAppointmentModel] = []

        model.forEach { recordModel in
            group.enter()
            network.performRequest(
                type: .getRecord(
                    company_id: Int(recordModel.company_id) ?? 0,
                    record_id: Int(recordModel.record_id) ?? 0), expectation: GetRecordModel.self
            ) { [weak self] result in
                guard let self else { return }
                self.makeModel(result) { [weak self] model in

                    let isVisitValid = self?.isVisitVailed(visit_time: model.date)
                    if model.deleted || isVisitValid == true {
                        servicesProvidedSortedModel.append(model)
                    } else {
                        waitingServiceSortedModel.append(model)
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            self.waitingServicesModel = waitingServiceSortedModel.sorted(by: { $0.create_date > $1.create_date })
            self.servicesProvidedModel = servicesProvidedSortedModel.sorted(by: { $0.create_date > $1.create_date })
        }
    }

    private func makeModel(
        _ getRecord: GetRecordModel,
        completion: ((UIAppointmentModel) -> Void)
    ) {
        if let dataBaseModel = Array(
            realm.get(RecordDataBaseModel.self)).first(where: { Int($0.record_id) == getRecord.data.id })
        {
            completion(UIAppointmentModel(networkModel: getRecord.data, dataBaseModel: dataBaseModel))
        }
    }

    private func isVisitVailed(visit_time: String) -> Bool? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let date = Date()
        let moscowTimeZone = TimeZone(identifier: "Europe/Moscow")!
        let currentDate = date.addingTimeInterval(TimeInterval(moscowTimeZone.secondsFromGMT(for: date)))

        if let visitDate = dateFormatter.date(from: visit_time) {
            return currentDate > visitDate
        } else {
            print("Не удалось преобразовать строку в дату")
            return nil
        }
    }
}
