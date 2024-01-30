//
//  VerifyPresenter.swift
//  ZAND
//
//  Created by Василий on 26.12.2023.
//

import Foundation
import YandexMobileMetrica

enum VerifyType {
    case changeEmail
    case none
}

protocol VerifyOutput: AnyObject {
    var view: VerifyInput { get }

    func verify(code: String)
}

protocol VerifyInput: AnyObject {
    func popToRoot()
    func showAlert()
}

final class VerifyPresenter: VerifyOutput {

    // MARK: - Properties

    var verifyType: VerifyType?

    unowned let view: VerifyInput

    private let dateOfBirth: Date

    private let network: ZandAppAPI

    // MARK: - Initializers

    init(
        view: VerifyInput,
        network: ZandAppAPI,
        verifyType: VerifyType?=nil,
        dateOfBirth: Date = Date()
    ) {
        self.view = view
        self.dateOfBirth = dateOfBirth
        self.network = network
        self.verifyType = verifyType
    }

    // MARK: - Instance methods

    func verify(code: String) {
        network.performRequest(
            type: .verify(VerifyModel(verifyCode: code)),
            expectation: DefaultType.self
        ) { [weak self] _, isSuccess in
            guard let self else { return }

            if isSuccess {
                // евент об успешной регистрации
                YMMYandexMetrica.reportEvent("registration_completed", parameters: nil, onFailure: nil)
                // отправка юзера с его возрастом
                sendUserDataToYandexMetrica()
                YMMYandexMetrica.sendEventsBuffer()

                if (self.verifyType ?? .none) == .changeEmail {
                    self.view.popToRoot()
                    NotificationCenter.default.post(name: .signOut, object: nil)
                } else {
                    self.view.popToRoot()
                }
            } else {
                self.view.showAlert()
            }
        } error: { _ in }
    }

    private func sendUserDataToYandexMetrica() {
        let userProfile = YMMMutableUserProfile()

        userProfile.apply(from: [
            // Updating predefined attributes.
            YMMProfileAttribute.birthDate().withAge(userAge())
        ])

        YMMYandexMetrica.report(userProfile, onFailure: nil)
    }

    func userAge() -> UInt {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: dateOfBirth, to: Date())
        return UInt(Double(components.year ?? 0))
    }
}
