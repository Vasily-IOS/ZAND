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
        .init(description: StringsAsset.name),
        .init(description: StringsAsset.surname),
        .init(description: StringsAsset.age),
        .init(description: StringsAsset.email),
        .init(description: StringsAsset.phoneNumber)
    ]
}
