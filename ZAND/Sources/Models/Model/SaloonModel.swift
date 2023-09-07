//
//  SaloonModel.swift
//  ZAND
//
//  Created by Василий on 05.09.2023.
//

import Foundation

struct Saloons: Codable {
    let data: [Saloon]
}

struct Saloon: Codable, SaloonMapModel, CommonFilterProtocol {
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
    let bookforms: [BookForm]
    let default_bookform_url: String
}

struct BookForm: Codable {
    let id: Int
    let title: String
    let is_default: Int
    let url: String
}
