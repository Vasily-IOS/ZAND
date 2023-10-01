//
//  OptionModel.swift
//  ZAND
//
//  Created by Василий on 24.04.2023.
//

import UIKit

struct OptionsModel: CommonFilterProtocol {
    let name: String
    let image: UIImage
    
    static let options: [Self] = [
        .init(name: AssetString.filter, image: UIImage(named: "filter_icon")!),
        .init(name: AssetString.hair, image: UIImage(named: "scissors_icon")!),
        .init(name: AssetString.nail, image: UIImage(named: "nails_icon")!),
        .init(name: AssetString.spa, image: UIImage(named: "massage_icon")!),
        .init(name: AssetString.makeUp, image: UIImage(named: "makeup_icon")!),
        .init(name: AssetString.face_care, image: UIImage(named: "faceCare_icon")!),
        .init(name: AssetString.brows, image: UIImage(named: "brows_icon")!),
        .init(name: AssetString.mens, image: UIImage(named: "mens_icon")!)
    ]
    
    static let optionWithoutFilterModel: [Self] = [
        .init(name: AssetString.hair, image: UIImage(named: "scissors_icon")!),
        .init(name: AssetString.nail, image: UIImage(named: "nails_icon")!),
        .init(name: AssetString.spa, image: UIImage(named: "massage_icon")!),
        .init(name: AssetString.makeUp, image: UIImage(named: "makeup_icon")!),
        .init(name: AssetString.face_care, image: UIImage(named: "faceCare_icon")!),
        .init(name: AssetString.brows, image: UIImage(named: "brows_icon")!),
        .init(name: AssetString.mens, image: UIImage(named: "mens_icon")!)
    ]
}
