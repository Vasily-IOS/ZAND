//
//  StaffModel.swift
//  ZAND
//
//  Created by Василий on 19.09.2023.
//

import Foundation

protocol EmployeeCommon {
    var id: Int { get }
    var name: String { get }
    var company_id: Int { get }
    var specialization: String { get }
    var avatar: String { get }
    var avatar_big: String { get }
    var fired: Int { get }
    var hidden: Int { get }
    var status: Int { get }
    var is_bookable: Bool { get }
    var schedule_till: String? { get }
}

struct EmployeeModel: Codable {
    let success: Bool
    let data: [Employee]
}

struct Employee: EmployeeCommon, Codable {
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
