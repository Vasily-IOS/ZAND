//
//  Extension + String.swift
//  ZAND
//
//  Created by Василий on 21.07.2023.
//

import Foundation

extension String {

    private var regex: NSRegularExpression {
        return try! NSRegularExpression(pattern: RegexMask.phone, options: .caseInsensitive)
    }

    func numberCorrector(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String {
        guard !(shouldRemoveLastDigit && phoneNumber.count <= 2) else {
            return "+"
        }

        let maxNumberCount = 11
        let range = NSString(string: phoneNumber).range(of: phoneNumber)
        var number = regex.stringByReplacingMatches(in: phoneNumber,
                                                    options: [],
                                                    range: range,
                                                    withTemplate: "")

        if number.count > maxNumberCount {
            let maxIndex = number.index(number.startIndex, offsetBy: maxNumberCount)
            number = String(number[number.startIndex..<maxIndex])
        }

        if shouldRemoveLastDigit {
            let maxIndex = number.index(number.startIndex, offsetBy: number.count - 1)
            number = String(number[number.startIndex..<maxIndex])
        }

        let maxIndex = number.index(number.startIndex, offsetBy: number.count)
        let regRange = number.startIndex..<maxIndex

        if number.count < 7 {
            let pattern = "(\\d)(\\d{3})(\\d+)"
            number = number.replacingOccurrences(of: pattern,
                                                 with: "$1 ($2) $3",
                                                 options: .regularExpression,
                                                 range: regRange)
        } else {
            let pattern = "(\\d)(\\d{3})(\\d{3})(\\d{2})(\\d+)"
            number = number.replacingOccurrences(of: pattern,
                                                 with: "$1 ($2) $3-$4-$5",
                                                 options: .regularExpression,
                                                 range: regRange)
        }

        return "+" + number
    }
}
