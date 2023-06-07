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
    case saloonDetail(SaloonMockModel)
    case register
    case filter
    case profile
    case appointments
    case settings
    case booking
    case selectableMap(String)
}
