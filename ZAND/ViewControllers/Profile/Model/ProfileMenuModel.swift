//
//  ProfileMenuModel.swift
//  ZAND
//
//  Created by Василий on 27.04.2023.
//

import UIKit

struct ProfileMenuModel {
    let image: UIImage
    let description: String
    
    static let model: [Self] = [
        .init(image: UIImage(named: "books_icon")!, description: Strings.books),
        .init(image: UIImage(named: "settings_icon")!, description: Strings.settings),
        .init(image: UIImage(named: "logout_icon")!, description: Strings.logOut)
    ]
}
