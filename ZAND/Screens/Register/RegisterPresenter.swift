//
//  RegisterPresenter.swift
//  ZAND
//
//  Created by Василий on 07.06.2023.
//

import Foundation

protocol RegisterPresenterOutput: AnyObject {
    var registerModel: RegisterModel { get set }
    var codeAreSuccessfullySended: Bool { get set  }

    func enterNamePhone()
    func enterSmsCode()
    func numberCorrector(phoneNumber: String, shouldRemoveLastDigit: Bool) -> String
}

protocol RegisterViewInput: AnyObject {
    func showAlert(type: AlertType)
    func dismiss()

    func updateUI(state: RegisterViewState)
}

enum AlertType {
    case enterYourName
    case phoneNumberLessThanEleven
    case codeIsInvalid
    case enterYourCode

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
        }
    }
}

enum RegisterViewState {
    case sendCode
    case showProfile
}

final class RegisterPresenter: RegisterPresenterOutput {

    // MARK: - Properties

    weak var view: RegisterViewInput?
    var registerModel = RegisterModel()
    var codeAreSuccessfullySended: Bool = false

    private var regex: NSRegularExpression {
        return try! NSRegularExpression(pattern: RegexMask.phone, options: .caseInsensitive)
    }

    // MARK: - Initializers

    init(view: RegisterViewInput) {
        self.view = view
    }

    // MARK: - Instance properties

    func enterNamePhone() {
        if registerModel.name.isEmpty {
            view?.showAlert(type: .enterYourName)
        } else if registerModel.phone.count < 11 {
            view?.showAlert(type: .phoneNumberLessThanEleven)
        } else {
            AuthManagerImpl.shared.startAuth(phone: registerModel.phone) { [weak self] success in
                guard success else { return }

                self?.codeAreSuccessfullySended = true
                self?.view?.updateUI(state: .sendCode)
            }
        }
    }

    func enterSmsCode() {
        if registerModel.verifyCode.isEmpty {
            view?.showAlert(type: .enterYourCode)
        } else {
            AuthManagerImpl.shared.verifyCode(code: registerModel.verifyCode) { [weak self] success in
                guard success else { return }

                self?.view?.updateUI(state: .showProfile)
            }
        }
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
