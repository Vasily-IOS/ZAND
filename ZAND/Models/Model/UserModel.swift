//
//  UserModel.swift
//  ZAND
//
//  Created by Василий on 22.07.2023.
//

import Foundation
import AuthenticationServices

struct UserModel: Codable {
    let name: String
    let phone: String
}

struct User {

    // MARK: - Nested types

    enum UserState {
        case notAllFieldsAreFilledIn
        case emailIsNotCorrect
        case phoneIsNotCorrect
        case policyIsNotConfirmed
        case phoneNumberCountIsSmall
        case register
    }

    // MARK: - Properties

    var id: String
    var name: String
    var surname: String
    var email: String
    var phone: String = ""
    var isPolicyConfirmed: Bool = false

    var fullName: String {
        return "\(surname)" + " " + "\(name)"
    }

    private var isAllFieldsFilled: Bool {
        return name != "" && surname != "" && email != "" && phone.count == 18
    }

    private var isEmailCanValidate: Bool {
        return isEmailCorrect(email: email)
    }

    private var isPhoneCorrect: Bool {
        return phone.prefix(5) == "+7 (9"
    }

    private var isPhoneCountIsCorrect: Bool {
        return phone.count == 18
    }

    // MARK: - Initializers

    init(credential: ASAuthorizationAppleIDCredential) {
        id = credential.user
        name = credential.fullName?.givenName ?? ""
        surname = credential.fullName?.familyName ?? ""
        email = credential.email ?? ""
    }

    // MARK: - Instance methods

    func isCanRegister() -> UserState {
        if !isAllFieldsFilled {
            return .notAllFieldsAreFilledIn
        } else if !isEmailCanValidate {
            return .emailIsNotCorrect
        } else if !isPhoneCorrect {
            return .phoneIsNotCorrect
        } else if !isPolicyConfirmed {
            return .policyIsNotConfirmed
        } else if !isPhoneCountIsCorrect {
            return .phoneNumberCountIsSmall
        } else {
            return .register
        }
    }

    private func isEmailCorrect(email: String) -> Bool {
        let emailPattern = RegexMask.email
        let isEmailCorrect = email.range(of: emailPattern, options: .regularExpression)
        return (isEmailCorrect != nil)
    }
}
