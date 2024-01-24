//
//  CreateUserModel.swift
//  ZAND
//
//  Created by Василий on 26.12.2023.
//

import Foundation

struct CreateUserModel: Codable {
    let firstName: String // required // имя
    var middleName: String // отчество
    let lastName: String // required // фамилия
    let email: String // required
    let phone: String // required
    var birthday: String
    let password: String // required
}
