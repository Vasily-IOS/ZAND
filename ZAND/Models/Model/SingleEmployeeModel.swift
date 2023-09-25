//
//  SingleEmployee.swift
//  ZAND
//
//  Created by Василий on 25.09.2023.
//

import Foundation

struct SingleEmployeeModel: Codable {
    let data: SingleEmployee
}

struct SingleEmployee: Codable, EmployeeCommon {
    let id: Int
    let name: String
    let company_id: Int
    let specialization: String
    let avatar: String
    let avatar_big: String
    let fired: Int
    let hidden: Int // Скрыт ли сотрудник для онлайн-записи, 1 - скрыт, 0 - не скрыт
    let status: Int // Удален ли сотрудник, 1 - удален, 0 - не удален
    let is_bookable: Bool
    let schedule_till: String?
}
