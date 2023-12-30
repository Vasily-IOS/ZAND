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
}

extension SettingsViewController: SettingsInput {

    // MARK: - SettingsInput methods

    func configure(model: UserDataBaseModel) {
        contentView.configure(model: model)
    }

    func changeUIAppearing(type: SaveType) {
        contentView.changeUIAppearing(type: type)
    }
}
