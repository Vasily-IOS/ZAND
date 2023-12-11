//
//  CategoriesModel.swift
//  ZAND
//
//  Created by Василий on 23.09.2023.
//

import Foundation

struct CategoriesModel {
    let category: CategoryJSONModel // категория
    let services: [BookServiceModel] // сервисы в категории
    var isOpened: Bool = false // открыта ли секция с сервисами
}

struct ServicesModel: Codable {
    let success: Bool
    let data: [ServiceModel]
}

struct ServiceModel: Codable {
    let id: Int
    let booking_title: String
    let service_type: Int
    let api_service_id: Int
    let price_prepaid_percent: Int
    let salon_service_id: Int
    let title: String
    let category_id: Int
    let price_min: Int
    let price_max: Int
    let discount: Int
    let staff: [StaffModel]
    let duration: Int
    let is_online: Bool
    let comment: String
}

struct StaffModel: Codable {
    let id: Int
    let name: String
}

struct CategoriesJSONModel: Codable {
    let data: [CategoryJSONModel]
}

struct CategoryJSONModel: Codable, Hashable {
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
