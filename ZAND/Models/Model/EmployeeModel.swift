//
//  EmployeeModel.swift
//  ZAND
//
//  Created by Василий on 19.09.2023.
//

import Foundation

protocol EmployeeCommon {
    var id: Int { get }
    var name: String { get }
    var specialization: String { get }
    var avatar: String { get }
    var schedule_till: String? { get }
}

struct EmployeeModel: Codable {
    let success: Bool
    let data: [Employee]
}

struct Employee: EmployeeCommon, Codable {
    let id: Int
    let name: String
    let specialization: String
    let avatar: String
    let schedule_till: String?
}
