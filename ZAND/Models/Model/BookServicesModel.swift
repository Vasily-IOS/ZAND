//
//  BookServicesModel.swift
//  ZAND
//
//  Created by Василий on 26.09.2023.
//

import Foundation

struct BookServicesModel: Codable {
    let data: DataServicesModel
}

struct DataServicesModel: Codable {
    let services: [BookServiceModel]
}

struct BookServiceModel: Codable {
    let id: Int
    let title: String
    let category_id: Int
    let price_min: Int
    let price_max: Int
    let discount: Int
    let active: Int
    let comment: String?
}
