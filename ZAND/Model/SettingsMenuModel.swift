//
//  Settings.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

struct SettingsMenuModel: Hashable {
    let description: String

    static let model: [Self] = [
        .init(description: StringsAsset.name),
        .init(description: StringsAsset.surname),
        .init(description: StringsAsset.age),
        .init(description: StringsAsset.email),
        .init(description: StringsAsset.phoneNumber)
    ]
}
