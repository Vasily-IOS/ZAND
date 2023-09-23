//
//  Categories.swift
//  ZAND
//
//  Created by Василий on 23.09.2023.
//

import Foundation

// общая модель
struct Categories {
    let category: CategoryJSON
    let services: [Service]
    var isOpened: Bool = false
}

// модель сервиса
struct Services: Codable {
    let success: Bool
    let data: [Service]
}

struct Service: Codable {
    let booking_title: String
    let service_type: Int
    let api_service_id: Int
    let price_prepaid_percent: Int
    let id: Int
    let salon_service_id: Int
    let title: String
    let category_id: Int
    let price_min: Int
    let price_max: Int
    let discount: Int
    let staff: [Staff]
    let duration: Int
    let is_online: Bool
    let comment: String
}

struct Staff: Codable {
    let id: Int
//    let seance_length: Int
//    let technological_card_id: Int
//    let image_url: String
    let name: String
}
