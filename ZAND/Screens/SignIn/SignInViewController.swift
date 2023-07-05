//
//  SignInViewController.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit

final class SignInViewController: BaseViewController<SignInView> {
    
    // MARK: - Properties
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
    }
    
    deinit {
        print("SignInViewController died")
    }

    // MARK: - Instance methods

    private func subscribeDelegate() {
        contentView.delegate = self
    }
}

extension SignInViewController: SignInDelegate {

    // MARK: - SignInDelegate methods

    func stopEditing() {
        contentView.endEditing(true)
    }

    func navigateToRegister() {
        AppRouter.shared.push(.register)
    }

    func navigatetoProfile() {
        AppRouter.shared.push(.profile)
    }
}

extension SignInViewController: HideNavigationBar {}
