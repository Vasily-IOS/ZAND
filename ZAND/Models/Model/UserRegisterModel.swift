//
//  UserRegisterModel.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

import Foundation

struct UserRegisterModel: Codable {

    // MARK: - Nested types

    enum UserState {
        case notAllRequiredFieldsAreFilled // не все обязательные поля заполнены
        case emailIsNotCorrect // email не верен
        case phoneIsNotCorrect // телефон не верен
        case policyIsNotConfirmed // политика конф не принята
        case phoneNumberCountIsSmall // мало цифр телефона
        case passwordCountIsSmall // кол-во символов пароля меньше 8
        case passwordAreNotEqual
        case register // можно регаться
    }

    // MARK: - Properties

    var name: String = "" // required
    var surname: String = "" // required
    var fathersName: String = ""
    var email: String = "" // required
    var phone: String = "" // required
    var birthday: String = ""
    var password: String = "" // required
    var repeatPassword: String = ""
    var isPolicyConfirmed: Bool = false

    private var isAllFieldsFilled: Bool {
        return !name.isEmpty && !surname.isEmpty && !email.isEmpty && !phone.isEmpty && (!password.isEmpty && !repeatPassword.isEmpty)
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

    private var isPasswordValidLength: Bool {
        let password = password.trimmingCharacters(in: .whitespaces)
        return password.count >= 8
    }

    private var isPasswordsEqual: Bool {
        let password = password.trimmingCharacters(in: .whitespaces)
        let repeatPassword = repeatPassword.trimmingCharacters(in: .whitespaces)
        
        return password == repeatPassword
    }

    // MARK: - Instance methods

    func isCanRegister() -> UserState {
        if !isAllFieldsFilled {
            return .notAllRequiredFieldsAreFilled
        } else if !isEmailCanValidate {
            return .emailIsNotCorrect
        } else if !isPhoneCorrect {
            return .phoneIsNotCorrect
        } else if !isPolicyConfirmed {
            return .policyIsNotConfirmed
        } else if !isPhoneCountIsCorrect {
            return .phoneNumberCountIsSmall
        } else if !isPasswordValidLength {
            return .passwordCountIsSmall
        } else if !isPasswordsEqual {
            return .passwordAreNotEqual
        } else {
            return .register
        }
    }

    private func isEmailCorrect(email: String) -> Bool {
        let emailPattern = Regex.email
        let isEmailCorrect = email.range(of: emailPattern, options: .regularExpression)
        return (isEmailCorrect != nil)
    }
}
