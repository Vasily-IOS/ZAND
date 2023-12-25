//
//  TokenModel.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

import Foundation

struct TokenModel: Codable {
    let accessToken: String
    let refreshToken: String
    let savedDate: Date
}
