//
//  SalonsCodableModel.swift
//  ZAND
//
//  Created by Василий on 05.09.2023.
//

import Foundation

struct SalonsCodableModel: Codable {
    let data: [SaloonCodableModel]
}

struct SaloonCodableModel: Codable {
    let id: Int
    let title: String
    let public_title: String
    let short_descr: String
    let logo: String
    let city_id: Int
    let city: String
    let active: Int
    let schedule: String
    let address: String
    let coordinate_lat: Double
    let coordinate_lon: Double
    let description: String
    let photos: [String]
    let company_photos: [String]
    let default_bookform_url: String
    let business_type_id: Int
}

extension SaloonCodableModel: Hashable {
    static func == (lhs: SaloonCodableModel, rhs: SaloonCodableModel) -> Bool {
        lhs.id == rhs.id
    }
}
