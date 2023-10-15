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
    case gotError
    case enterPhone
    case fillAllFields
    case invalidEmailInput
    case shouldAcceptPolicy
    case invalidPhoneInput

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
        case .gotError:
            return AssetString.gotError
        case .enterPhone:
            return AssetString.enterPhone
        case .fillAllFields:
            return AssetString.fillAllFields
        case .invalidEmailInput:
            return AssetString.invalidEmailInput
        case .shouldAcceptPolicy:
            return AssetString.shouldAcceptPolicy
        case .invalidPhoneInput:
            return AssetString.phoneInput
        }
    }
}