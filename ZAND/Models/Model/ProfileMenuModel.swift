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

    static let model: [Self] = [
        .init(image: AssetImage.books_icon.image, description: AssetString.books.rawValue),
        .init(image: AssetImage.logout_icon.image, description: AssetString.logOut.rawValue),
        .init(image: AssetImage.deleteProfile_icon.image, description: AssetString.deleteProfile.rawValue)
    ]
}
