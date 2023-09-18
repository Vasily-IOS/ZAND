//
//  RegisterNViewController.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import UIKit

final class RegisterViewController: BaseViewController<RegisterView> {

    // MARK: - Properties

    var presenter: RegisterPresenterOutput?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegates()
    }

    // MARK: - Instance methods

    private func subscribeDelegates() {
        contentView.delegate = self

        contentView.delegate = self
        [contentView.nameTextField,
         contentView.surnameTextField,
         contentView.emailTextField,
         contentView.phoneTextField
        ].forEach {
            $0.delegate = self
        }
    }
}

extension RegisterViewController: RegisterDelegate {

    // MARK: - RegisterNDelegate methods
    
    func cancelEditing() {
        contentView.endEditing(true)
    }

    func register() {
        if presenter?.user.isAllFieldsFilled == true {
            if presenter?.user.isEmailCanValidate == true {
                if presenter?.user.isPolicyConfirmed == true {
                    presenter?.save()
                    AppRouter.shared.popViewController()
                    AppRouter.shared.switchRoot(type: .profile)
                } else {
                    AppRouter.shared.showAlert(type: .shouldAcceptPolicy, message: nil)
                }
            } else {
                AppRouter.shared.showAlert(type: .invalidEmailInput, message: nil)
            }
        } else {
            AppRouter.shared.showAlert(type: .fillAllFields, message: nil)
        }
    }

    func showPolicy() {
        AppRouter.shared.presentWithNav(type: .privacyPolicy(URLS.privacy_policy))
    }

    func changePolicy(isConfirmed: Bool) {
        presenter?.user.isPolicyConfirmed = isConfirmed
        print(isConfirmed)
    }
}

extension RegisterViewController: UITextFieldDelegate {

    // MARK: - UITextViewDelegate methods

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == contentView.phoneTextField {
            guard let text = textField.text else { return false }

            let phoneString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = text.format(with: "+X (XXX) XXX-XX-XX", phone: phoneString)

            if (textField.text?.count ?? 0) == 18 && (presenter?.keyboardAlreadyHidined ?? false) == false {
                presenter?.keyboardAlreadyHidined = true
                contentView.hidePhoneKeyboard()
            }

            textField.text == "" || textField.text?.count != 18 || textField.text == "+7" ?
            contentView.makeRedBorder() : contentView.removeBorder()

            return false
        }
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""

        switch textField {
        case contentView.nameTextField:
            presenter?.user.name = text
        case contentView.surnameTextField:
            presenter?.user.surname = text
        case contentView.emailTextField:
            presenter?.user.email = text
        case contentView.phoneTextField:
            presenter?.user.phone = text
        default:
            break
        }
    }
}

extension RegisterViewController: RegisterViewInput {}
