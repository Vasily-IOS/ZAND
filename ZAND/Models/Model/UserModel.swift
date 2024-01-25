//
//  UserModel.swift
//  ZAND
//
//  Created by Василий on 27.12.2023.
//

import Foundation

struct UserModel: Codable {
    let data: User
}

struct User: Codable {
    let lastName: String
    let middleName: String
    let firstName: String
    let email: String
    let phone: String
    let birthday: String
}
