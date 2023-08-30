//
//  VCType.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import Foundation

enum VCType {
    case tabBar
    case search([SaloonMockModel])
    case main
    case map
    case saloonDetail(SaloonDetailType)
    case filter
    case profile
    case appointments
    case myDetails
    case booking
    case selectableMap(CommonModel)
    case appleSignIn
    case registerN(User)
}
