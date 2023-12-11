//
//  BookTimesModel.swift
//  ZAND
//
//  Created by Василий on 26.09.2023.
//

import Foundation

struct BookTimesModel: Codable {
    let data: [BookTimeModel]
}

struct BookTimeModel: Codable {
    let time: String
    let seance_length: Int
    let datetime: String
}
