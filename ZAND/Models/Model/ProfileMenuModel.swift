//
//  ProfileMenuModel.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import UIKit

struct ProfileMenuModel {
    let image: UIImage?
    let description: String
    let color: UIColor?

    static let model: [Self] = [
        .init(image: AssetImage.books_icon.image, description: AssetString.books.rawValue, color: nil),
        .init(image: AssetImage.settings_icon.image, description: AssetString.settings.rawValue, color: nil),
        .init(image: AssetImage.logout_icon.image, description: AssetString.logOut.rawValue, color: nil),
        .init(image: UIImage(named: "trash_icon"), description: AssetString.deleteProfile.rawValue, color: .red)
    ]
}
