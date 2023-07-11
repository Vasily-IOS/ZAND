//
//  SignInViewController.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit

final class SignInViewController: BaseViewController<SignInView> {
    
    // MARK: - Properties

    var presenter: SignInPresenterOutput?
    
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
        [contentView.emailTextField, contentView.passwordTextField].forEach {
            $0.delegate = self
        }
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

    func signIn() {
        presenter?.signIn()
//        AppRouter.shared.push(.profile)
    }
}

extension SignInViewController: UITextFieldDelegate {

    // MARK: - UITextFieldDelegate methods

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""

        switch textField {
        case contentView.emailTextField:
            presenter?.email = text
        case contentView.passwordTextField:
            presenter?.password = text
        default:
            break
        }
    }
}

extension SignInViewController: SignInViewInput {

    // MARK: - SignInViewInput methods

    func signInSuccess() {
        view.backgroundColor = .red
    }
}

extension SignInViewController: HideNavigationBar {}
