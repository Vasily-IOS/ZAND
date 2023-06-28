//
//  AppointmentsModel.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import Foundation

struct AppointmentsModel: CommonModel {
    let saloon_name: String
    let saloon_address: String
    let bookingDate: String
    let bookingTime: String
    let serviceName: String
    let servicePrice: Int
    let isServiceIsDelivered: Bool
    let coordinates: String
    
    static let model: [Self] = [
        .init(saloon_name: "Beautiful eyes",
              saloon_address: "Колпачный переулок, д. 6, стр. 4",
              bookingDate: "Cуббота, 11 марта, 2023",
              bookingTime: "12:00 - 13:00",
              serviceName: "Женская стрижка",
              servicePrice: 2000,
              isServiceIsDelivered: false,
              coordinates: "55.933301,37.514214"),
        .init(saloon_name: "Good smiles",
              saloon_address: "Колпачный переулок, д. 6, стр. 4",
              bookingDate: "Cуббота, 11 марта, 2023",
              bookingTime: "13:00 - 14:00",
              serviceName: "Женская укладка",
              servicePrice: 1000,
              isServiceIsDelivered: true,
              coordinates: "55.763908,37.60646"),
        .init(saloon_name: "Wella krasavella",
              saloon_address: "Проспект Андропова д.4",
              bookingDate: "Cуббота, 11 марта, 2023",
              bookingTime: "15:00 - 16:00",
              serviceName: "Наращивание ноктевых суставов",
              servicePrice: 700,
              isServiceIsDelivered: false,
              coordinates: "55.583205,37.59674"),
        .init(saloon_name: "Приукрасим так приукрасим",
              saloon_address: "Долголетия улица д.7",
              bookingDate: "Cуббота, 11 марта, 2023",
              bookingTime: "10:00 - 11:00",
              serviceName: "Липасакция",
              servicePrice: 500,
              isServiceIsDelivered: true,
              coordinates: "55.751665,37.817169"),
    ]
}
