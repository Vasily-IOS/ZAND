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
    let remoteId: Int // new
    let title: String
    let publicTitle: String // name changed from public_title
    let shortDescription: String // name changed from short_descr
    let logo: String
    let cityId: Int // name changed from city_Id
    let city: String
    let active: Int
    let schedule: String
    let address: String
    let latitude: Double // name changed from coordinate_lat
    let longitude: Double // name changed from coordinate_lon
    let description: String
    let type: String // new
    let photos: [String]
    let companyPhotos: [String] // name changed from company_photos
    let defaultBookFormUrl: String // name changed from default_bookform_url
    let target: String // new
    let categories: [Category] // instead business_type_id. Пока что берется первая категория
//    let business_type_id: Int ??
}

struct Category: Codable, Hashable {
    let id: Int
    let name: String
    let description: String
}

extension SaloonCodableModel: Hashable {
    static func == (lhs: SaloonCodableModel, rhs: SaloonCodableModel) -> Bool {
        lhs.id == rhs.id
    }
}
