//
//  WorkingRangeItemModel.swift
//  ZAND
//
//  Created by Василий on 26.09.2023.
//

import Foundation

struct WorkingRangeItemModel {
    let dateString: String
    let dayNumeric: String
    let dayString: String

    var date: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString) ?? Date()
    }
}
