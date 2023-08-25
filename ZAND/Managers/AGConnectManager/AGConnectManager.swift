//
//  AGConnectManager.swift
//  ZAND
//
//  Created by Василий on 25.08.2023.
//

import Foundation
import AGConnectAuth

protocol AGConnectManager {
    // Get verify code
    func sendVerifyCode(phoneNumber: String, completion: @escaping (Bool) -> Void)
    // Register a user using a mobile number and verifyCode
    func createUser(phoneNumber: String, verifyCode: String, completion: @escaping (Bool) -> Void)
    // log out
    func logOut()
}

final class AGConnectManagerImpl: AGConnectManager {

    static let shared: AGConnectManager = AGConnectManagerImpl()

    private init() {}

    // MARK: - Properties

    let setting = AGCVerifyCodeSettings.init(
        action: AGCVerifyCodeAction.registerLogin,
        locale: nil,
        sendInterval: 10)

    // MARK: - Instance methods

    func sendVerifyCode(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        AGCPhoneAuthProvider.requestVerifyCode(
            withCountryCode: "7",
            phoneNumber: phoneNumber,
            settings: setting
        ).onSuccess{ (result) in
            print("Code sended")
            completion(true)
        }.onFailure{ (error) in
            print("Code is not sended")
            completion(false)
        }
    }

    func createUser(phoneNumber: String, verifyCode: String, completion: @escaping (Bool) -> Void) {

//        AGCAuth.instance().crea
        AGCAuth.instance().createUser(
            withCountryCode: "7",
            phoneNumber: phoneNumber,
            password: nil,
            verifyCode: verifyCode
        ).onSuccess{ (result) in
            print("User created")
            completion(true)
        }.onFailure{ (error) in
            print("User is not created")
            completion(false)
        }
    }

    func logOut() {
        AGCAuth.instance().signOut()
    }
}
