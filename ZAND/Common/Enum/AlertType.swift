//
//  AlertType.swift
//  ZAND.
//
//  Created by Василий on 25.07.2023.
//

import Foundation

enum AlertType {
    case enterYourName
    case phoneNumberLessThanEleven
    case codeIsInvalid
    case enterYourCode
    case phoneInputError

    var textValue: String {
        switch self {
        case .enterYourName:
            return AssetString.enterYourName
        case .phoneNumberLessThanEleven:
            return AssetString.phoneNumberLessThanEleven
        case .codeIsInvalid:
            return AssetString.codeIsInvalid
        case .enterYourCode:
            return AssetString.enterYourCode
        case .phoneInputError:
            return AssetString.phoneInputError
        }
    }
}
