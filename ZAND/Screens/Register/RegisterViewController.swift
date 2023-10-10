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
        subscribeNotifications()
    }

    // MARK: - Instance methods

    @objc
    private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        let contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        contentView.scrollView.contentInset = contentInset
    }

    @objc
    private func keyboardWillHide(notification: NSNotification) {
        contentView.scrollView.contentInset = .zero
    }

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

    private func showFinalAlertController() {
        let finalText = "\n\(AssetString.name): \(presenter?.user.fullName ?? "")\n\(AssetString.email): \(presenter?.user.email ?? "")\n\(AssetString.phone): \(presenter?.user.phone ?? "")"
        let alertController = UIAlertController(
            title: AssetString.checkYourData, message: finalText, preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: AssetString.fix, style: .destructive)
        
        let confirmAction = UIAlertAction(title: AssetString.good, style: .cancel) { [weak self]_ in
            self?.presenter?.save()
            AppRouter.shared.popViewController()
            AppRouter.shared.switchRoot(type: .profile)
        }

        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)

        present(alertController, animated: true)
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
        guard let step = presenter?.user.isCanRegister() else { return }

        switch step {
        case .notAllFieldsAreFilledIn:
            AppRouter.shared.showAlert(type: .fillAllFields, message: nil)
        case .emailIsNotCorrect:
            AppRouter.shared.showAlert(type: .invalidEmailInput, message: nil)
        case .phoneIsNotCorrect:
            AppRouter.shared.showAlert(type: .invalidPhoneInput, message: nil)
        case .policyIsNotConfirmed:
            AppRouter.shared.showAlert(type: .shouldAcceptPolicy, message: nil)
        case .phoneNumberCountIsSmall:
            AppRouter.shared.showAlert(type: .phoneNumberLessThanEleven, message: nil)
        case .register:
            showFinalAlertController()
        }
    }

    func showPolicy() {
        AppRouter.shared.presentWithNav(type: .privacyPolicy(URLS.privacy_policy))
    }

    func changePolicy(isConfirmed: Bool) {
        presenter?.user.isPolicyConfirmed = isConfirmed
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
