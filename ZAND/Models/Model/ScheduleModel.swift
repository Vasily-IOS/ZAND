//
//  ScheduleModel.swift
//  ZAND
//
//  Created by Василий on 23.09.2023.
//

import Foundation

struct ScheduleModel: Codable {
    let success: Bool
    let data: [Schedule]
    let meta: [String]
}

struct Schedule: Codable {
    let date: String
    let is_working: Int
//    let slots: []  ???
}
