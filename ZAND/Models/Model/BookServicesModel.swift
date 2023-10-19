//
//  BookServicesModel.swift
//  ZAND
//
//  Created by Василий on 26.09.2023.
//

import Foundation

struct BookServicesModel: Codable {
    let data: DataServices
}

struct DataServices: Codable {
    let services: [BookService]
}

struct BookService: Codable {
    let id: Int
    let title: String
    let category_id: Int
    let price_min: Int
    let price_max: Int
    let discount: Int
    let active: Int
    let comment: String?
}
