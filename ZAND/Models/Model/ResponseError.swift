//
//  ResponseError.swift
//  ZAND
//
//  Created by Василий on 23.01.2024.
//

import Foundation

enum ErrorKind {
    case emailRegistered
    case phoneRegistered
}

struct ResponseError: Codable {
    let code: Int?
    let error: String
}
