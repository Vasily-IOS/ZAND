//
//  OptionModel.swift
//  ZAND
//
//  Created by Василий on 24.04.2023.
//

import UIKit

enum FilterID: Int {
    case beautySaloon = 1 // cалон красоты
    case nail = 45 // ногти
    case massage = 29 // массаж
    case cosmetology = 35 // косметология
    case spa = 25 // SPA
    case eyes = 48 // глаза (брови и ресницы)
    case epilation = 101 // епиляция и депиляция
    case barbershop = 18 // мужчинам (барбершоп)
}

struct OptionsModel: CommonFilterProtocol {
    let id: Int?
    let name: String
    let image: UIImage
    
    static let options: [Self] = [
        .init(id: nil, name: AssetString.filter.rawValue, image: UIImage(named: "filter_icon")!),
        .init(id: FilterID.beautySaloon.rawValue, name: AssetString.hair.rawValue, image: UIImage(named: "scissors_icon")!),
        .init(id: FilterID.nail.rawValue, name: AssetString.nail.rawValue, image: UIImage(named: "nails_icon")!),
        .init(id: FilterID.massage.rawValue, name: AssetString.massage.rawValue, image: UIImage(named: "massage_icon")!),
        .init(id: FilterID.cosmetology.rawValue, name: AssetString.cosmetology.rawValue, image: UIImage(named: "makeup_icon")!),
        .init(id: FilterID.spa.rawValue, name: AssetString.spa.rawValue, image: UIImage(named: "faceCare_icon")!),
        .init(id: FilterID.eyes.rawValue, name: AssetString.eyes.rawValue, image: UIImage(named: "brows_icon")!),
        .init(id: FilterID.epilation.rawValue, name: AssetString.epilation.rawValue, image: UIImage(named: "epilation_icon")!),
        .init(id: FilterID.barbershop.rawValue, name: AssetString.mens.rawValue, image: UIImage(named: "mens_icon")!)
    ]

    static func optionsWithoutFilter() -> [Self] {
        return Array(options.dropFirst())
    }
}
