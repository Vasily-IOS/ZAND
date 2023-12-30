//
//  SettingsViewController.swift
//  ZAND
//
//  Created by Василий on 29.12.2023.
//

import UIKit

final class SettingsViewController: BaseViewController<SettingsView> {

    // MARK: - Properties

    var presenter: SettingsPresenter?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegates()
        subscribeNotifications()

        navigationController?.navigationBar.isUserInteractionEnabled = false
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
        contentView.getAllTextFields().forEach { $0.delegate = self }
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

extension SettingsViewController: UITextFieldDelegate {

    // MARK: - UITextFieldDelegate methods

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        if textField == contentView.phoneView.textField {
            guard let text = textField.text else { return false }

            let phoneString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = text.format(with: "+X (XXX) XXX-XX-XX", phone: phoneString)

            return false
        }
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }

        switch textField {
        case contentView.nameView.textField:
            presenter?.name = text
        case contentView.surnameView.textField:
            presenter?.surname = text
        case contentView.fatherNameView.textField:
            presenter?.fathersName = text
        case contentView.phoneView.textField:
            presenter?.phone = text
        case contentView.emailView.textField:
            presenter?.email = text
        default:
            break
        }
    }
}

extension SettingsViewController: SettingsViewDelegate {

    // MARK: - SettingsViewDelegate methods

    func cancelEditing() {
        contentView.endEditing(true)
    }

    func save() {
        presenter?.save()
        presenter?.saveType = .default
    }

    func changeAll() {
        presenter?.saveType = .all
    }

    func changeEmail() {
        presenter?.saveType = .email
    }

    func cancelChanges() {
        presenter?.saveType = .default
    }

    func setBirthday(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        presenter?.birthday = dateFormatter.string(from: date)
    }
}

extension SettingsViewController: SettingsInput {

    // MARK: - SettingsInput methods

    func configure(model: UserDataBaseModel) {
        contentView.configure(model: model)
    }

    func changeUIAppearing(type: SaveType) {
        contentView.changeUIAppearing(type: type)
    }

    func showSmthWentWrongAlert() {
        AppRouter.shared.showAlert(type: .smthWentWrong, message: nil)
    }
}
