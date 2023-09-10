//
//  VCType.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import Foundation

enum VCType {
    case tabBar
    case search([Saloon])
    case main
    case map
    case saloonDetail(SaloonDetailType)
    case filter
    case profile
    case appointments
    case myDetails
    case booking
    case selectableMap(SaloonMapModel)
    case appleSignIn
    case registerN(User)

//    case onMapSelect(SaloonMapModel)
}
