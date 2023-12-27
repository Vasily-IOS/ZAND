//
//  RegisterViewController.swift
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
        subscribeNotifications()
        hideBackButtonTitle()

        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Instance methods

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        contentView.setNewScrollInset(
            inset: UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        )
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        contentView.setNewScrollInset(inset: .zero)
    }

    private func subscribeDelegates() {
        contentView.delegate = self
        contentView.getAllTextFileds().forEach { $0.delegate = self }
    }

    private func subscribeNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification, object: nil
        )
    }
}

extension RegisterViewController: RegisterDelegate {

    // MARK: - RegisterNDelegate methods
    
    func cancelEditing() {
        contentView.endEditing(true)
    }

    func register() {
//        guard let step = presenter?.user.isCanRegister() else { return }
//
//        switch step {
//        case .notAllRequiredFieldsAreFilled:
//            AppRouter.shared.showAlert(type: .fillAllRequiredFields, message: nil)
//        case .emailIsNotCorrect:
//            AppRouter.shared.showAlert(type: .invalidEmailInput, message: nil)
//        case .phoneIsNotCorrect:
//            AppRouter.shared.showAlert(type: .invalidPhoneInput, message: nil)
//        case .policyIsNotConfirmed:
//            AppRouter.shared.showAlert(type: .shouldAcceptPolicy, message: nil)
//        case .phoneNumberCountIsSmall:
//            AppRouter.shared.showAlert(type: .phoneNumberLessThanEleven, message: nil)
//        case .passwordAreNotEqual:
//            AppRouter.shared.showAlert(type: .passwwordsIsNotEqual, message: nil)
//        case .passwordCountIsSmall:
//            AppRouter.shared.showAlert(type: .passwordCountIsSmall, message: nil)
//        case .register:
//            presenter?.register { response in
                AppRouter.shared.push(.verify)
            }
//        }
//    }

    func showPolicy() {
        AppRouter.shared.presentRecordNavigation(
            type: .privacyPolicy(AssetURL.privacy_policy.rawValue)
        )
    }

    func changePolicy(isConfirmed: Bool) {
        presenter?.user.isPolicyConfirmed = isConfirmed
    }

    func setBirthday(birthday: Date) {
        presenter?.setBirthday(birthday: birthday)
    }
}

extension RegisterViewController: UITextFieldDelegate {

    // MARK: - UITextViewDelegate methods

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if textField == contentView.phoneTextField {
            guard let text = textField.text else { return false }

            let phoneString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = text.format(with: "+X (XXX) XXX-XX-XX", phone: phoneString)

            if (textField.text?.count ?? 0) == 18 && (presenter?.keyboardAlreadyHidined ?? false) == false {
                presenter?.keyboardAlreadyHidined = true
                contentView.hidePhoneKeyboard()
            }
            return false
        }
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }

        switch textField {
        case contentView.nameTextField:
            presenter?.setName(name: text)
        case contentView.surnameTextField:
            presenter?.setSurname(surname: text)
        case contentView.fathersNameTextField:
            presenter?.setFatherName(fatheName: text)
        case contentView.emailTextField:
            presenter?.setEmail(email: text)
        case contentView.phoneTextField:
            presenter?.setPhone(phone: text)
        case contentView.createPasswordTextField:
            presenter?.setPassword(password: text)
        case contentView.repeatPasswordTextField:
            presenter?.setRepeatPassword(password: text)
        default:
            break
        }
    }
}

extension RegisterViewController: RegisterViewInput, HideBackButtonTitle {}
