//
//  SettingsMenuModel.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

struct SettingsMenuModel: Hashable {
    let description: String

    static let model: [Self] = [
        .init(description: AssetString.name.rawValue),
        .init(description: AssetString.email.rawValue),
        .init(description: AssetString.phoneNumber.rawValue)
    ]
}
