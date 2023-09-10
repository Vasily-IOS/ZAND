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
    case search([Saloon])
    case main
    case map
    case saloonDetail(SaloonDetailType)
    case filter
    case profile
    case appointments
    case myDetails
    case booking(String)
    case selectableMap(SaloonMapModel)
    case appleSignIn
    case registerN(User)
}
