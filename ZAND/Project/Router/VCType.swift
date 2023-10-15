//
//  VCType.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import Foundation

enum SaloonDetailType {
    case api(Saloon)
    case dataBase(SaloonDataBaseModel)
}

enum VCType {
    case tabBar
    case search(_ model: [Saloon])
    case main
    case map
    case saloonDetail(_ type: SaloonDetailType)
    case filter(_ dict: [IndexPath: Bool])
    case profile
    case appointments
    case privacyPolicy(_ urlString: String)
    case selectableMap(_ model: SaloonMapModel)
    case appleSignIn
    case register(_ user: User)
    case startBooking(Int, String, String)
    case services(
        booking_type: BookingType,
        company_id: Int,
        company_name: String,
        company_address: String
    )
    case staff(
        booking_type: BookingType,
        company_id: Int,
        company_name: String,
        company_address: String
    )
}
