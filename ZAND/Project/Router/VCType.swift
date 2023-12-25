//
//  VCType.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import Foundation

enum VCType {
    case tabBar
    case search(_ sortedModel: [Saloon], allModel: [Saloon], state: SearchState?=nil)
    case main
    case map
    case saloonDetail(_ model: Saloon)
    case filter(_ dict: [IndexPath: Bool], nearestIsActive: Bool)
    case profile
    case appointments
    case privacyPolicy(_ urlString: String)
    case selectableMap(_ model: Saloon)
    case signIn
    case register
    case resetPassword
    case refreshPassword

    case startBooking(Int, String, String)
    case services(
        booking_type: BookingType?=nil,
        company_id: Int?=nil,
        company_name: String?=nil,
        company_address: String?=nil,
        viewModel: ConfirmationViewModel?=nil
    )
    case staff(
        booking_type: BookingType?=nil,
        company_id: Int?=nil,
        company_name: String?=nil,
        company_address: String?=nil,
        viewModel: ConfirmationViewModel?=nil
    )
    case timeTable(viewModel: ConfirmationViewModel)
    case confirmation(viewModel: ConfirmationViewModel)
}
