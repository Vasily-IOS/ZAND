//
//  BookDatesModel.swift
//  ZAND
//
//  Created by Василий on 26.09.2023.
//

import Foundation

struct BookDatesModel: Codable {
    let data: BookDateModel
}

struct BookDateModel: Codable {
    let booking_dates: [String] // Массив дат, когда есть свободные сеансы на услугу к выбранному сотруднику/организации
    let working_dates: [String] // Массив дат, когда работает сотрудник/организация
}
