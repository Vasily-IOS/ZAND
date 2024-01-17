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
    case fillAllRequiredFields
    case invalidEmailInput
    case shouldAcceptPolicy
    case invalidPhoneInput
    case passwwordsIsNotEqual
    case passwordCountIsSmall
    case invalidEmailOrPassword
    case profileDeleted
    case smthWentWrong
    case emailsEqual
    case profileAlreadyExist

    var textValue: String {
        switch self {
        case .enterYourName:
            return AssetString.enterYourName.rawValue
        case .phoneNumberLessThanEleven:
            return AssetString.phoneNumberLessThanEleven.rawValue
        case .codeIsInvalid:
            return AssetString.codeIsInvalid.rawValue
        case .enterYourCode:
            return AssetString.enterYourCode.rawValue
        case .phoneInputError:
            return AssetString.phoneInputError.rawValue
        case .gotError:
            return AssetString.gotError.rawValue
        case .enterPhone:
            return AssetString.enterPhone.rawValue
        case .fillAllRequiredFields:
            return AssetString.fillAllRequiredFields.rawValue
        case .invalidEmailInput:
            return AssetString.invalidEmailInput.rawValue
        case .shouldAcceptPolicy:
            return AssetString.shouldAcceptPolicy.rawValue
        case .invalidPhoneInput:
            return AssetString.phoneInput.rawValue
        case .passwwordsIsNotEqual:
            return AssetString.passwIsNotEqual.rawValue
        case .passwordCountIsSmall:
            return AssetString.passwordCountIsSmall.rawValue
        case .invalidEmailOrPassword:
            return AssetString.invalidEmailOrPassword.rawValue
        case .profileDeleted:
            return AssetString.profileDeleted.rawValue
        case .smthWentWrong:
            return AssetString.smthWentWrong.rawValue
        case .emailsEqual:
            return AssetString.emailsEqual.rawValue
        case .profileAlreadyExist:
            return AssetString.profileAlreadyExist.rawValue
        }
    }
}
