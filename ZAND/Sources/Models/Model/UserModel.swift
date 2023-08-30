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
    var id: String
    var name: String
    var surname: String
    var email: String
    var phone: String = ""

    var isAllFieldsFilled: Bool {
        return name != "" && surname != "" && email != "" && phone.count == 18
    }

    var isEmailCanValidate: Bool {
        return isEmailCorrect(email: email)
    }

    init(credential: ASAuthorizationAppleIDCredential) {
        id = credential.user
        name = credential.fullName?.givenName ?? ""
        surname = credential.fullName?.familyName ?? ""
        email = credential.email ?? ""
    }

    func isEmailCorrect(email: String) -> Bool {
        let emailPattern = RegexMask.email
        let isEmailCorrect = email.range(of: emailPattern, options: .regularExpression)
        return (isEmailCorrect != nil)
    }
}
