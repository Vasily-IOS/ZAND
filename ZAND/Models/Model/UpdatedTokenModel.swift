//
//  UpdatedTokenModel.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

import Foundation

struct UpdatedTokenModel: Codable {
    let data: UpdatedSingleModel
}

struct UpdatedSingleModel: Codable {
    let userId: Int
    let email: String
    let token: String
    let refreshToken: String
}
