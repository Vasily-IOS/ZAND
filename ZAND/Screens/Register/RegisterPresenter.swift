//
//  RegisterPresenter.swift
//  ZAND
//
//  Created by Василий on 07.06.2023.
//

import Foundation

protocol RegisterPresenterOutput: AnyObject {
    var registerModel: RegisterModel { get set }
    var filledFields: Int { get set }

    func register()
    func numberCorrector(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String
}

protocol RegisterViewInput: AnyObject {
    func showAlert(type: AlertType)
    func dismiss()
}

enum AlertType {
    case incorrectEmail
    case isPasswordsEqual
    case passwordCountLessThanSix
    case phoneNumberLessThanEleven
    case fillAllFields

    var textValue: String {
        switch self {
        case .incorrectEmail:
            return "Неправильно введен Email"
        case .isPasswordsEqual:
            return "Пароли не совпадают"
        case .passwordCountLessThanSix:
            return "Количество символов в пароле меньше 6"
        case .phoneNumberLessThanEleven:
            return "Общее количество символов телефона должно быть 11"
        case .fillAllFields:
            return "Заполните все поля"
        }
    }
}

final class RegisterPresenter: RegisterPresenterOutput {

    // MARK: - Properties

    weak var view: RegisterViewInput?

    var requiredFieldCount: Int = 5
    var filledFields: Int = 0

    var registerModel = RegisterModel()

    private var regex: NSRegularExpression {
        return try! NSRegularExpression(pattern: RegexMask.phone, options: .caseInsensitive)
    }

    // MARK: - Initializers

    init(view: RegisterViewInput) {
        self.view = view
    }

    // MARK: - Instance properties

    func register() {
        if !(filledFields == requiredFieldCount) {
            view?.showAlert(type: .fillAllFields)
        } else if !isEmailCorrect(email: registerModel.email) {
            view?.showAlert(type: .incorrectEmail)
        } else if registerModel.phone.count < 11 {
            view?.showAlert(type: .phoneNumberLessThanEleven)
        } else if !registerModel.isPasswordsEqual {
            view?.showAlert(type: .isPasswordsEqual)
        } else if registerModel.password.count < 6 || registerModel.confirmPassword.count < 6 {
            view?.showAlert(type: .passwordCountLessThanSix)
        } else {
            AuthManagerImpl.shared.registerUser(model: registerModel) { [weak self] result in
                if result == true {
                    self?.view?.dismiss()
                }
            }
        }
    }

    func isEmailCorrect(email: String) -> Bool {
        let emailPattern = RegexMask.email
        let isEmailCorrect = email.range(of: emailPattern, options: .regularExpression)
        return (isEmailCorrect != nil)
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
