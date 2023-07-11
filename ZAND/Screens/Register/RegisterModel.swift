//
//  RegisterModel.swift
//  ZAND
//
//  Created by Василий on 11.07.2023.
//

import Foundation

struct RegisterModel {
    var name: String = ""
    var email: String = ""
    var phone: String = ""
    var password: String = ""
    var confirmPassword: String = ""

    var isPasswordsEqual: Bool {
        return password == confirmPassword
    }
}
