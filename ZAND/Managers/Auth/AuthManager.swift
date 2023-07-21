//
//  AuthManager.swift
//  ZAND
//
//  Created by Василий on 11.07.2023.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

protocol AuthManager: AnyObject {
    func startAuth(phone: String, completion: @escaping ((Bool) -> Void))
    func verifyCode(code: String, completion: @escaping ((Bool) -> Void))
    func logOut()
}

final class AuthManagerImpl: AuthManager {

    // MARK: - Properties

    static let shared = AuthManagerImpl()

    private var verificationID: String?

    private let auth = Auth.auth()

    private let reference = Database.database().reference().child("users")

    // MARK: - Initializers

    private init() {}

    // MARK: - Instance methods

    func startAuth(phone: String, completion: @escaping ((Bool) -> Void)) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { [weak self] verificationID, error in
            guard let verificationID = verificationID,
                  error == nil else {
                completion(false)
                return
            }

            self?.verificationID = verificationID
            completion(true)
        }
    }

    func verifyCode(code: String, completion: @escaping ((Bool) -> Void)) {
        guard let verificationID = verificationID else {
            completion(false)
            return
        }

        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID, verificationCode: code
        )

        auth.signIn(with: credential) { authCredential, error in
            guard authCredential != nil, error == nil else {
                completion(false)
                return
            }

            completion(true)
        }
    }

    func logOut() {
        do {
          try auth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}
