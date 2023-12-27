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
        user.name = name
    }

    func setSurname(surname: String) {
        user.surname = surname
    }

    func setFatherName(fatheName: String) {
        user.fathersName = fatheName
    }

    func setEmail(email: String) {
        user.email = email
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
        user.password = password
    }

    func setRepeatPassword(password: String) {
        user.repeatPassword = password
    }

    func register(completion: @escaping (Bool) -> ()) {
        let createUserModel = CreateUserModel(
            firstName: user.name.trimmingCharacters(in: .whitespaces),
            middleName: user.fathersName.trimmingCharacters(in: .whitespaces),
            lastName: user.surname.trimmingCharacters(in: .whitespaces),
            email: user.email.trimmingCharacters(in: .whitespaces),
            phone: user.phone,
            birthday: user.birthday,
            password: user.password.trimmingCharacters(in: .whitespaces)
        )

        network.performRequest(
            type: .register(createUserModel), expectation: ServerResponse.self
        ) { response in
            print(response)
            completion(true)
        }
    }
}
