//
//  ConfirmationModel.swift
//  ZAND
//
//  Created by Василий on 28.09.2023.
//

import Foundation

// создание записи

struct ConfirmationModel: Codable {
    let phone: String // required
    let fullname: String // required
    let email: String
    var comment: String = "Тестовая запись ZAND"
    var notify_by_sms: Int = 2 // За сколько часов до визита следует выслать смс напоминание клиенту (0 - если не нужно)
    var notify_by_email: Int = 0 //За сколько часов до визита следует выслать email напоминание клиенту (0 - если не нужно)
    let api_id: Int //ID записи из внешней системы
    let appointments: [Appointment]
}

struct Appointment: Codable {
    let id: Int // required // Идентификатор записи для обратной связи после сохранения (смотри ответ на запрос).
    let services: [Int] // Массив идентификаторов услуг, на которые клиент хочет записаться
    let staff_id: Int // required // Идентификатор специалиста, к которому клиент хочет записаться (0 если выбран любой мастер)
    let datetime: String // required // Дата и время сеанса в формате ISO8601 (передается для каждого сеанса в ресурсе book_times)
}
