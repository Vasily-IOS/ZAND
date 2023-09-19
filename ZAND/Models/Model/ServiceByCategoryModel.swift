//
//  ServiceByCategoryModel.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import Foundation

struct ServiceByCategoryModel: Codable {
    let success: Bool
    let data: [Service]
    let meta: Meta
}

struct Service: Codable, Hashable {
    let id: Int
    let category_id: Int
    let salon_service_id: Int
    let title: String
    let weight: Int
    let api_id: String
    let staff: [Int]
    let booking_title: String
    let price_min: Int
    let price_max: Int
    let sex: Int
    let is_chain: Bool
}

struct Meta: Codable {
    let total_count: Int
}
