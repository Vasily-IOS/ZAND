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
    let id: String
    let name: String
    let surname: String
    let email: String
//    let phone: String

    init(credential: ASAuthorizationAppleIDCredential) {
        id = credential.user
        name = credential.fullName?.givenName ?? ""
        surname = credential.fullName?.familyName ?? ""
        email = credential.email ?? ""
    }
}
