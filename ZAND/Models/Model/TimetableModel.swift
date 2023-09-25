//
//  TimetableModel.swift
//  ZAND
//
//  Created by Василий on 25.09.2023.
//

import Foundation

struct TimetableModel: Codable {
    let success: Bool
    let data: [Freetime]
}

struct Freetime: Codable {
    let time: String
    let is_free: Bool
}
