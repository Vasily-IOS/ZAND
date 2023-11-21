//
//  FilterModel.swift
//  ZAND
//
//  Created by Василий on 19.11.2023.
//

import UIKit

struct FilterModel: CommonFilterProtocol {
    let title: String

    static let model: [Self] = [
        .init(title: AssetString.near)
    ]
}
