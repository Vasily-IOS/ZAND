//
//  RegisterModel.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

import Foundation

struct RegisterModel: Codable {
    let firstName: String // required
    let middleName: String
    let lastName: String // required
    let email: String // required
    let phone: String // required
    let birthday: String
    let password: String // required
}
