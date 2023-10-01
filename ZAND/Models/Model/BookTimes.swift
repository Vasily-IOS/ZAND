//
//  BookTimes.swift
//  ZAND
//
//  Created by Василий on 26.09.2023.
//

import Foundation

struct BookTimes: Codable {
    let data: [BookTime]
}

struct BookTime: Codable {
    let time: String
    let seance_length: Int
    let datetime: String
}
