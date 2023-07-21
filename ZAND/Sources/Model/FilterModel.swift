//
//  Filter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

struct FilterModel: CommonFilterProtocol {
    let filterDescription: String

    static let filterModel: [Self] = [
        .init(filterDescription: AssetString.highGrade),
        .init(filterDescription: AssetString.chip),
        .init(filterDescription: AssetString.expensive),
    ]
}
