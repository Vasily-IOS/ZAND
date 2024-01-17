//
//  RegisterPresenter.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import Foundation

protocol RegisterPresenterOutput: AnyObject {
    var keyboardAlreadyHidined: Bool { get set }
    var user: UserRegisterModel { get set }

    func setName(name: String)
    func setSurname(surname: String)
    func setFatherName(fatheName: String)
    func setEmail(email: String)
    func setPhone(phone: String)
    func setBirthday(birthday: Date)
    func setPassword(password: String)
    func setRepeatPassword(password: String)

    func register(completion: @escaping (Bool) -> ())
}

protocol RegisterViewInput: AnyObject {}

final class RegisterPresenter: RegisterPresenterOutput {

    // MARK: - Properties

    weak var view: RegisterViewInput?

    var keyboardAlreadyHidined: Bool = false

    var user = UserRegisterModel()

    private let network: APIManagerAuthP

    // MARK: - Initializers

    init(view: RegisterViewInput, network: APIManagerAuthP) {
        self.view = view
        self.network = network
    }

    // MARK: - Instance methods

    func setName(name: String) {
        user.name = name.trimmingCharacters(in: .whitespaces)
    }

    func setSurname(surname: String) {
        user.surname = surname.trimmingCharacters(in: .whitespaces)
    }

    func setFatherName(fatheName: String) {
        user.fathersName = fatheName.trimmingCharacters(in: .whitespaces)
    }

    func setEmail(email: String) {
        user.email = email.trimmingCharacters(in: .whitespaces)
    }

    func setPhone(phone: String) {
        user.phone = phone
    }

    func setBirthday(birthday: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        user.birthday = dateFormatter.string(from: birthday)
    }

    func setPassword(password: String) {
        user.password = password.trimmingCharacters(in: .whitespaces)
    }

    func setRepeatPassword(password: String) {
        user.repeatPassword = password.trimmingCharacters(in: .whitespaces)
    }

    func register(completion: @escaping (Bool) -> ()) {
        let createUserModel = CreateUserModel(
            firstName: user.name,
            middleName: user.fathersName,
            lastName: user.surname,
            email: user.email,
            phone: user.phone,
            birthday: user.birthday,
            password: user.password
        )

        network.performRequest(
            type: .register(createUserModel), expectation: ServerResponse.self
        ) { response, isSuccess in
            if isSuccess {
                if let response = response {
                    completion(true)
                    print("Register is valid. Response is \(response.data)")
                }
            } else {
                completion(false)
                print("Register is invalid")
            }
        }
    }
}
