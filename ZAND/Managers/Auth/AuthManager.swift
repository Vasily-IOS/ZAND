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
    func isUserLogged() -> Bool
    func registerUser(model: RegisterModel, completion: @escaping (Bool) -> Void)
    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void)
    func signOut()
}

final class AuthManagerImpl: AuthManager {

    // MARK: - Properties

    static let shared = AuthManagerImpl()

    private let auth = Auth.auth()

    private let reference = Database.database().reference().child("users")

    // MARK: - Initializers

    private init() {}

    // MARK: - Instance methods

    func isUserLogged() -> Bool {
        return auth.currentUser == nil
    }

    func registerUser(model: RegisterModel, completion: @escaping (Bool) -> Void) {
        auth.createUser(withEmail: model.email, password: model.password) { [weak self] result, error in
            guard let self else { return }

            if result != nil, error == nil {
                if let result = result {
                    self.reference.child(result.user.uid).updateChildValues(
                        ["phoneNumber": model.phone,
                         "email": model.email,
                         "displayName": model.name
                        ]
                    )
                }
                print("User created")
                completion(true)
            } else {
                completion(false)
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Bool) -> Void) {
        if !email.isEmpty && !password.isEmpty {
            auth.signIn(withEmail: email, password: password) { result, error in
                if result != nil, error == nil {
                    print("Logged successfull")
                    if let result = result {

                    }
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
    }

    func signOut() {
        do {
            print("LogOut")
            try auth.signOut()
        } catch let error {
            debugPrint(error)
        }
    }
}
