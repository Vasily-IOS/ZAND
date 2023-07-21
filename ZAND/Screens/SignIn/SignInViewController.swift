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
        [contentView.nameTextField,
         contentView.phoneTextField,
         contentView.smsCodeTextField].forEach {
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
        if !presenter!.codeAreSuccessfullySended {
            presenter?.enterNamePhone()
        } else {
            presenter?.enterSmsCode()
        }
    }
}

extension SignInViewController: UITextFieldDelegate {

    // MARK: - UITextFieldDelegate methods

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""

        switch textField {
        case contentView.nameTextField:
            presenter?.registerModel.name = text
        case contentView.phoneTextField:
            presenter?.registerModel.phone = text
        case contentView.smsCodeTextField:
            presenter?.registerModel.verifyCode = text
        default:
            break
        }
    }
}

extension SignInViewController: SignInViewInput {

    // MARK: - SignInViewInput methods

    func showAlert(type: AlertType) {
        AppRouter.shared.showAlert(type: type)
    }

    func updateUI(state: RegisterViewState) {
        switch state {
        case .sendCode:
            contentView.updateUI()
        case .showProfile:
            AppRouter.shared.switchRoot(type: .profile)
        }
    }

    func dismiss() {
        AppRouter.shared.popViewController()
    }
}

extension SignInViewController: HideNavigationBar {}
