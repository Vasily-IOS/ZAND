//
//  GetRecordModel.swift
//  ZAND
//
//  Created by Василий on 12.10.2023.
//

import Foundation

enum AttendanceID: Int {
    case waiting = 0 // ожидание пользователя
    case userConfirmed = 2 // пользователь подтвердил запись
}

struct GetRecordModel: Codable {
    let success: Bool
    let data: GetRecord
}

struct GetRecord: Codable, Hashable {
    let id: Int // id записи
    let company_id: Int // id компании
    let services: [ServiceRecord] // записи
    let date: String // дата сеанса
    let datetime:  String // дата сеанса в ISO
    let visit_attendance: Int // cтатус визита
    let attendance: Int // Статус записи
    let confirmed: Int // Статус подтверждения записи, 0 - не подтверждена, 1 - подтверждена
    let seance_length: Int? // длительность сеанса
    let length: Int? // длительность сеанса
    let api_id: String // внешний идентификатор записи
    let create_date: String
    let deleted: Bool 
}

struct ServiceRecord: Codable, Hashable {
    let id: Int //
    let title: String // название услуги
    let cost: Float // итоговая стоимость услуги
    let cost_per_unit: Float // cтоимость за единицу
}
