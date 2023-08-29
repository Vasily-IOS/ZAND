//
//  AGConnectManager.swift
//  ZAND
//
//  Created by Василий on 25.08.2023.
//

import Foundation
import AGConnectAuth

protocol AGСConnectManager {
    var user: AGCUser? { get }

    func sendVerifyCode(name: String, phoneNumber: String, completion: @escaping (Bool) -> Void)
    func signIn(code: String, completion: @escaping (Bool) -> Void)
    func signOut()
}

final class AGСConnectManagerImpl: AGСConnectManager {

    static let shared: AGСConnectManager = AGСConnectManagerImpl()

    private init() {}

    // MARK: - Properties

    var name: String = ""
    var phone: String = ""

    var user: AGCUser? {
        return AGCAuth.instance().currentUser
    }

    private let uDmanager: UDManagerImpl = UDManager()

    // MARK: - This group of methods used for registration

    func sendVerifyCode(name: String, phoneNumber: String, completion: @escaping (Bool) -> Void) {
        let setting = AGCVerifyCodeSettings.init(
            action: AGCVerifyCodeAction.registerLogin,
            locale: nil,
            sendInterval: 10)

        AGCPhoneAuthProvider.requestVerifyCode(
            withCountryCode: Config.countyCode,
            phoneNumber: String(phoneNumber.filter("0123456789".contains).dropFirst()),
            settings: setting
        ).onSuccess{ [weak self] (result) in
            print("Code sended")

            self?.name = name
            self?.phone = phoneNumber

            completion(true)
        }.onFailure{ (error) in
            print("Code is not sended")
            completion(false)
        }
    }

    func signIn(code: String, completion: @escaping (Bool) -> Void) {
        let credential = AGCPhoneAuthProvider.credential(
            withCountryCode: Config.countyCode,
            phoneNumber: String(phone.filter("0123456789".contains).dropFirst()),
            password: nil,
            verifyCode: code
        )

        print("Credential created")

        AGCAuth.instance().signIn(
            credential: credential
        ).onSuccess { [weak self] (result) in
            guard let self else { return }

            print("Sign In complete")

            completion(true)
        }.onFailure{ (error) in
            print("Sign In Error")
            completion(false)
        }
    }

    func signOut() {
        AGCAuth.instance().signOut()
    }
}
