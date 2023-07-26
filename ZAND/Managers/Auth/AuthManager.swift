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

    var currentUser: User? {
        return auth.currentUser
    }

    private var verificationID: String?

    private let auth = Auth.auth()

    private let uDmanager: UDManagerImpl = UDManager()

    // MARK: - Initializers

    private init() {}

    // MARK: - Instance methods

    func startAuth(name: String, phone: String, completion: @escaping ((Bool) -> Void)) {
        NotificationCenter.default.post(name: .showIndicator, object: nil)
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { [weak self] verificationID, error in
            guard let verificationID = verificationID,
                  error == nil else {
                debugPrint("Error of start auth: \(String(describing: error))")
                completion(false)
                return
            }

            self?.name = name
            self?.verificationID = verificationID
            completion(true)
        }
    }

    func verifyCode(code: String, completion: @escaping ((Bool) -> Void)) {
        NotificationCenter.default.post(name: .showIndicator, object: nil)
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
                debugPrint("Error of code verifying: \(String(describing: error))")
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
