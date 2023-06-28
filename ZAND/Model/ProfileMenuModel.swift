//
//  ProfileMenu.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import UIKit

struct ProfileMenuModel {
    let image: UIImage
    let description: String

    static let model: [Self] = [
        .init(image: ImageAsset.books_icon!, description: StringsAsset.books),
        .init(image: ImageAsset.settings_icon!, description: StringsAsset.settings),
        .init(image: ImageAsset.logout_icon!, description: StringsAsset.logOut)
    ]
}
