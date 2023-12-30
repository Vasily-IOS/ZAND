//
//  UserDataBaseModel.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import Foundation

struct UserDBModel: Codable {
    let name: String
    let surname: String
    let fathersName: String
    let birthday: String
    let phone: String
    var email: String
}
