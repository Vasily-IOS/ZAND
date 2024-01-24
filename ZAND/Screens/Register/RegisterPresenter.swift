//
//  RegisterPresenter.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import Foundation

enum RegisterState {
    case success
    case failure(Int)
}

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

    func register()
}

protocol RegisterViewInput: AnyObject {
    func registerStepAction(state: RegisterState)
}

final class RegisterPresenter: RegisterPresenterOutput {

    // MARK: - Properties

    weak var view: RegisterViewInput?

    var keyboardAlreadyHidined: Bool = false

    var user = UserRegisterModel()

    private let network: ZandAppAPI

    // MARK: - Initializers

    init(view: RegisterViewInput, network: ZandAppAPI) {
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

    func register() {
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
        ) { [weak self] response, isSuccess in
            if isSuccess {
                self?.view?.registerStepAction(state: .success)
                print("Register is valid. Response is \(response?.data)")
            } else {
                print(response?.data)
            }
        } error: { [weak self] error in
            print("Register is NOT valid.")
            if let errorModel = try? JSONDecoder().decode(ResponseError.self, from: error) {
                switch errorModel.code {
                case 0:
                    self?.view?.registerStepAction(state: .failure(0))
                    print("Пользователь с почтой уже зарегистрирован.")
                case 1:
                    self?.view?.registerStepAction(state: .failure(1))
                    print("Пользователь с телефоном уже зарегистрирован.")
                default:
                    break
                }
            }
        }
    }
}
