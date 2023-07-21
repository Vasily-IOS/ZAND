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
    func startAuth(name: String, phone: String, completion: @escaping ((Bool) -> Void))
    func verifyCode(code: String, completion: @escaping ((Bool) -> Void))
    func logOut()
}

final class AuthManagerImpl: AuthManager {

    // MARK: - Properties

    static let shared = AuthManagerImpl()

    var name: String = ""

    private var verificationID: String?

    private let auth = Auth.auth()

    private let uDmanager: UDManagerImpl = UDManager()

    private let reference = Database.database().reference().child("users")

    // MARK: - Initializers

    private init() {}

    // MARK: - Instance methods

    func startAuth(name: String, phone: String, completion: @escaping ((Bool) -> Void)) {
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { [weak self] verificationID, error in
            guard let verificationID = verificationID,
                  error == nil else {
                completion(false)
                return
            }

            self?.name = name
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

            let model = UserModel(name: self.name, phone: authCredential?.user.phoneNumber ?? "")
            self.uDmanager.save(model, Config.userData)
            
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
