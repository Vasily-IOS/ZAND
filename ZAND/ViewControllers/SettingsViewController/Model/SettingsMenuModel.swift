//
//  SettingsMenuModel.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import Foundation

struct SettingsMenuModel {
    let description: String
    
    static let model: [Self] = [
        .init(description: Strings.name),
        .init(description: Strings.surname),
        .init(description: Strings.age),
        .init(description: Strings.email),
        .init(description: Strings.phoneNumber)
    ]
}
