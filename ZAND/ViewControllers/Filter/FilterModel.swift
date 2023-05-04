//
//  FilterModel.swift
//  ZAND
//
//  Created by Василий on 24.04.2023.
//

import Foundation

struct FilterModel {
    let filterDescription: String
    
    static let filterModel: [Self] = [
        .init(filterDescription: Strings.byDefault),
        .init(filterDescription: Strings.highGrade),
        .init(filterDescription: Strings.chip),
        .init(filterDescription: Strings.expensive),
    ]
}
