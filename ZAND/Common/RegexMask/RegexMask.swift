//
//  RegularExpressions.swift
//  ZAND
//
//  Created by Василий on 11.07.2023.
//

import Foundation

enum RegexMask {
    static let email = #"^\S+@\S+\.\S+$"#
    static let phone = "[\\+\\s-\\(\\)]"
}
