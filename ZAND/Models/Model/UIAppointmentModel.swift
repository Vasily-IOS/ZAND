//
//  UIAppointmentModel.swift
//  ZAND
//
//  Created by Василий on 13.10.2023.
//

import Foundation

struct UIAppointmentModel: Hashable {

    // MARK: - Nested types

    enum ButtonState {
        case none
        case cancelAppointment // отменить запись
        case appointmentCanceled // запись отменена
    }

    // MARK: - Properties
    
    let id: Int // id записи
    let company_name: String
    let company_address: String
    let company_id: Int // id компании
    let services: UIAppointmentRecordModel // записи
    let date: String // дата сеанса
    let datetime:  String // дата сеанса в ISO
    let visit_attendance: Int // cтатус визита
    let attendance: Int // Статус записи
    let seance_lenght_int: Int
    let create_date: String
    let deleted: Bool
    var buttonState: ButtonState = .none

    var seance_start_date: String {
        return makeStartSeanceDate(datetime)
    }

    var seance_start_time: String {
        return makeStartSeanceTime(seance_lenght_int, datetime)
    }

    // MARK: - Initializers

    init(networkModel: GetRecord, dataBaseModel: RecordDataBaseModel) {
        id = networkModel.id
        company_name = dataBaseModel.company_name
        company_address = dataBaseModel.company_address
        company_id = Int(dataBaseModel.company_id) ?? 0
        services = UIAppointmentRecordModel(model: networkModel.services.first!)
        date = networkModel.date
        datetime = networkModel.datetime
        visit_attendance = networkModel.visit_attendance
        attendance = networkModel.attendance
        seance_lenght_int = networkModel.seance_length ?? 0
        create_date = networkModel.create_date
        deleted = networkModel.deleted

        if deleted {
            buttonState = .appointmentCanceled
        } else if isVisitVailed(visit_time: networkModel.date) == false {
            buttonState = .cancelAppointment
        } else {
            buttonState = .none
        }
    }

    // MARK: - Instance methods

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

struct UIAppointmentRecordModel: Hashable {
    var title: String
    var cost: Int

    init(model: ServiceRecord) {
        title = model.title
        cost = Int(model.cost)
    }
}
