//
//  MainModel.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

struct OptionsModel {
    let name: String
    let image: UIImage
    
    static let options: [Self] = [
        .init(name: Strings.filter, image: UIImage(named: "filter_icon")!),
        .init(name: Strings.hair, image: UIImage(named: "scissors_icon")!),
        .init(name: Strings.nail, image: UIImage(named: "nails_icon")!),
        .init(name: Strings.spa, image: UIImage(named: "spa_icon")!)
    ]
}
