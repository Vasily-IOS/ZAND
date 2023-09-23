//
//  StaffModel.swift
//  ZAND
//
//  Created by Василий on 19.09.2023.
//

import Foundation

struct EmployeeModel: Codable {
    let success: Bool
    let data: [Employee]
}

struct Employee: Codable {
    let id: Int
    let name: String
    let company_id: Int
    let specialization: String
    let avatar: String
    let avatar_big: String
    let fired: Int
    let hidden: Int // Скрыт ли сотрудник для онлайн-записи, 1 - скрыт, 0 - не скрыт
    let is_bookable: Bool
    let schedule_till: String?
}
