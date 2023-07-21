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
        .init(image: AssetImage.books_icon!, description: AssetString.books),
        .init(image: AssetImage.settings_icon!, description: AssetString.details),
        .init(image: AssetImage.logout_icon!, description: AssetString.logOut)
    ]
}
