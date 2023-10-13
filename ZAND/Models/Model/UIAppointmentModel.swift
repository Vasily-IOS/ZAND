//
//  UIAppointmentModel.swift
//  ZAND
//
//  Created by Василий on 13.10.2023.
//

import Foundation

struct UIAppointmentModel: Hashable {
    let id: Int // id записи
    let company_name: String
    let company_address: String
    let company_id: Int // id компании
    let services: UIAppointmentRecord // записи
    let date: String // дата сеанса
    let datetime:  String // дата сеанса в ISO
    let visit_attendance: Int // cтатус визита
    let attendance: Int // Статус записи
    let confirmed: Int // Статус подтверждения записи, 0 - не подтверждена, 1 - подтверждена
    let seance_lenght_int: Int
    let create_date: String

    var seance_start_date: String {
        return makeStartSeanceDate(datetime)
    }

    var seance_start_time: String {
        return makeStartSeanceTime(seance_lenght_int, datetime)
    }

    init(networkModel: GetRecord, dataBaseModel: RecordDataBaseModel) {
        id = networkModel.id
        company_name = dataBaseModel.company_name
        company_address = dataBaseModel.company_address
        company_id = Int(dataBaseModel.company_id) ?? 0
        services = UIAppointmentRecord(model: networkModel.services.first!)
        date = networkModel.date
        datetime = networkModel.datetime
        visit_attendance = networkModel.visit_attendance
        attendance = networkModel.attendance
        confirmed = networkModel.confirmed
        seance_lenght_int = networkModel.seance_length ?? 0
        create_date = networkModel.create_date
    }

    private func makeStartSeanceDate(_ date: String) -> String {
        let date = try? Date(date, strategy: .iso8601)
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.locale = Locale(identifier: "ru_RU")

        return formatter.string(from: date ?? Date())
    }

    private func makeStartSeanceTime(_ seance_length: Int, _ bookTime: String) -> String {
        let date = (try? Date(bookTime, strategy: .iso8601)) ?? Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "ru_RU")
        let seanceLength = "\((seance_length) / 60) мин."
        let seanceFullData = (formatter.string(from: date)) + "," + " " + seanceLength

        return seanceFullData
    }
}

struct UIAppointmentRecord: Hashable {
    var title: String
    var cost: Int

    init(model: ServiceRecord) {
        title = model.title
        cost = Int(model.cost)
    }
}
