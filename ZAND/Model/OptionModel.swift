//
//  OptionModel.swift
//  ZAND
//
//  Created by Василий on 24.04.2023.
//

import UIKit

struct OptionsModel {
    let name: String
    let image: UIImage
    
    static let options: [Self] = [
        .init(name: StringsAsset.filter, image: UIImage(named: "filter_icon")!),
        .init(name: StringsAsset.hair, image: UIImage(named: "scissors_icon")!),
        .init(name: StringsAsset.nail, image: UIImage(named: "nails_icon")!),
        .init(name: StringsAsset.spa, image: UIImage(named: "spa_icon")!),
        .init(name: StringsAsset.makeUp, image: UIImage(named: "makeup_icon")!),
        .init(name: StringsAsset.face_care, image: UIImage(named: "faceCare_icon")!),
        .init(name: StringsAsset.brows, image: UIImage(named: "brows_icon")!),
        .init(name: StringsAsset.mens, image: UIImage(named: "mens_icon")!)
    ]
    
    static let optionWithoutFilterModel: [Self] = [
        .init(name: StringsAsset.hair, image: UIImage(named: "scissors_icon")!),
        .init(name: StringsAsset.nail, image: UIImage(named: "nails_icon")!),
        .init(name: StringsAsset.spa, image: UIImage(named: "spa_icon")!),
        .init(name: StringsAsset.makeUp, image: UIImage(named: "makeup_icon")!),
        .init(name: StringsAsset.face_care, image: UIImage(named: "faceCare_icon")!),
        .init(name: StringsAsset.brows, image: UIImage(named: "brows_icon")!),
        .init(name: StringsAsset.mens, image: UIImage(named: "mens_icon")!)
    ]
}
