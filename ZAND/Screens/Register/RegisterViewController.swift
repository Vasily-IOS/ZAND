//
//  RegisterViewController.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit

final class RegisterViewController: BaseViewController<RegisterView> {
    
    // MARK: - Properties

    var presenter: RegisterPresenterOutput?
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showNavigationBar()
    }
 
    deinit {
        print("RegisterViewController died")
    }
    
    // MARK: - Instance methods
    
    private func subscribeDelegate() {
        contentView.delegate = self
        [contentView.nameTextField,
         contentView.emailTextField,
         contentView.phoneTextField,
         contentView.passwordTextField,
         contentView.confirmPasswordTextField].forEach {
            $0.delegate = self
        }
    }
    
    private func sendNotify() {
        NotificationCenter.default.post(name: .showTabBar, object: nil)
    }
}

extension RegisterViewController: RegisterViewDelegate {
    
    // MARK: - Instance methods
    
    func skip() {
        removeFromParent()
        willMove(toParent: nil)
        view.removeFromSuperview()
        sendNotify()
        OnboardManager.shared.setIsNotNewUser()
    }

    func popViewController() {
        AppRouter.shared.popViewController()
    }

    func stopEditing() {
        contentView.endEditing(true)
    }

    func register() {
        presenter?.register()
    }
}

extension RegisterViewController: UITextFieldDelegate {

    // MARK: - UITextFieldDelegate methods

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == contentView.phoneTextField {
            let fullNumber = (textField.text ?? "") + string
            textField.text = presenter?.numberCorrector(phoneNumber: fullNumber,
                                                        shouldRemoveLastDigit: range.length == 1)
            return false
        }
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""

        switch textField {
        case contentView.nameTextField:
            presenter?.registerModel.name = text
        case contentView.emailTextField:
            presenter?.registerModel.email = text
        case contentView.phoneTextField:
            presenter?.registerModel.phone = text
        case contentView.passwordTextField:
            presenter?.registerModel.password = text
        case contentView.confirmPasswordTextField:
            presenter?.registerModel.confirmPassword = text
        default:
            break
        }

        presenter?.filledFields = [
            contentView.nameTextField, contentView.emailTextField, contentView.phoneTextField,
            contentView.passwordTextField, contentView.confirmPasswordTextField
        ].filter({ !($0.text ?? "").isEmpty}).count
    }
}

extension RegisterViewController: RegisterViewInput {

    // MARK: - RegisterViewInput methods

    func showAlert(type: AlertType) {
        AppRouter.shared.showAlert(type: type)
    }

    func dismiss() {
        AppRouter.shared.popViewController()
    }
}

extension RegisterViewController: ShowNavigationBar {}
