//
//  AuthManager.swift
//  ZAND
//
//  Created by Василий on 11.07.2023.
//

import UIKit

protocol AuthManager: AnyObject {
    func startAuth(name: String, phone: String, completion: @escaping ((Bool) -> Void))
    func verifyCode(code: String, completion: @escaping ((Bool) -> Void))
    func logOut()
}

final class AuthManagerImpl: AuthManager {

    // MARK: - Properties

    static let shared = AuthManagerImpl()

    var name: String = ""

    private var verificationID: String?

    private let uDmanager: UDManagerImpl = UDManager()

    // MARK: - Initializers

    private init() {}

    // MARK: - Instance methods

    func startAuth(name: String, phone: String, completion: @escaping ((Bool) -> Void)) {
        NotificationCenter.default.post(name: .showIndicator, object: nil)

    }

    func verifyCode(code: String, completion: @escaping ((Bool) -> Void)) {
        NotificationCenter.default.post(name: .showIndicator, object: nil)

    }

    func logOut() {
        
    }
}
