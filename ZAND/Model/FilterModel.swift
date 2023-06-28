//
//  Filter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

struct FilterModel {
    let filterDescription: String

    static let filterModel: [Self] = [
        .init(filterDescription: StringsAsset.highGrade),
        .init(filterDescription: StringsAsset.chip),
        .init(filterDescription: StringsAsset.expensive),
    ]
}
