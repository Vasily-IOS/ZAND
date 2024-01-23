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
        hideBackButtonTitle()

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
        contentView.getTextFields().forEach { $0.delegate = self }
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

    private func showAlert(text: String) {
        let alertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: AssetString.ok.rawValue, style: .cancel)
        alertController.addAction(action)
        navigationController?.present(alertController, animated: true)
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

            if range.length == 1 {
                if text != AssetString.phoneEnter.rawValue {
                    textField.text = String(text.dropLast())
                }
            } else {
                let phoneString = (text as NSString).replacingCharacters(in: range, with: string)
                textField.text = text.format(with: "+X (XXX) XXX-XX-XX", phone: phoneString)
            }

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

    func configure(model: UserDBModel) {
        contentView.configure(model: model)
    }

    func changeUIAppearing(type: SaveType) {
        contentView.changeUIAppearing(type: type)
    }

    func showSmthWentWrongAlert() {
        showAlert(text: AssetString.smthWentWrong.rawValue)
    }

    func changeDataAction(state: ChangeUserDataState) {
        switch state {
        case .success:
            presenter?.saveType = .default
        case .failure(let index):
            switch index {
            case 0:
                self.showAlert(text: AssetString.emailAlreadyExist.rawValue)
            case 1:
                self.showAlert(text: AssetString.phoneAlreadyExist.rawValue)
            default:
                break
            }
        }
    }

    func showEqualEmailAlert() {
        showAlert(text: AssetString.emailsEqual.rawValue)
    }

    func showIncorrectEmailAlert() {
        showAlert(text: AssetString.invalidEmailInput.rawValue)
    }

    func showLessMinCountNimberAlert() {
        showAlert(text: AssetString.phoneNumberLessThanEleven.rawValue)
    }

    func badInputNumberAlert() {
        showAlert(text: AssetString.phoneInputEleven.rawValue)
    }

    func navigateToVerify() {
        let factory: ViewControllerFactory = ViewControllerFactoryImpl()
        let vc = factory.getViewController(for: .verify(.changeEmail))
        navigationController?.pushViewController(vc, animated: true)
    }

    func dismiss() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.navigationController?.dismiss(animated: true)
        }
    }
}

extension SettingsViewController: HideBackButtonTitle {}
