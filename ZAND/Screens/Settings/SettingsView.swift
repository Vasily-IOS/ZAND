//
//  SettingsView.swift
//  ZAND
//
//  Created by Василий on 29.12.2023.
//

import UIKit

// Имя
// Фамилия
// Отчество
// Дата pождения
// Номер телефона
// Email -> меняется отдельно от всего

protocol SettingsViewDelegate: AnyObject {
    func save()
    func cancelEditing()
    func changeAll()
    func changeEmail()
    func cancelChanges()
}

final class SettingsView: BaseUIView {

    // MARK: - Properties

    weak var delegate: SettingsViewDelegate?

    private (set) var nameView = SettingsInputView(state: .name)

    private (set) var surnameView = SettingsInputView(state: .surname)

    private (set) var fatherNameView = SettingsInputView(state: .fathersName)

    private (set) var birthdayView = SettingsInputView(state: .birthday)

    private (set) var phoneView = SettingsInputView(state: .phone)

    private (set) var emailView = SettingsInputView(state: .email)

    private let scrollView = UIScrollView()

    private let contentView = UIView()

    private let changeUserDataButton = TransparentButton(state: .changeUserData)

    private let changeUserEmailButton = TransparentButton(state: .changeUserEmail)

    private let saveButton = BottomButton(buttonText: .save)

    private let cancelChangesButton: TransparentButton = {
        let button = TransparentButton(state: .cancelChanges)
        button.isHidden = true
        return button
    }()

    private lazy var stackView = UIStackView(
        alignment: .fill,
        arrangedSubviews: [
            nameView,
            surnameView,
            fatherNameView,
            birthdayView,
            phoneView
        ],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 30
    )

    // MARK: - Instance methods

    override func setup() {
        setupSubviews()
        setupRecognizer()
        setupTargets()
    }

    func configure(model: UserDataBaseModel) {
        nameView.setText(text: model.name)
        surnameView.setText(text: model.surname)
        fatherNameView.setText(text: model.fathersName)
        birthdayView.setText(text: model.birthday)
        phoneView.setText(text: model.phone)
        emailView.setText(text: model.email)
    }

    func setNewScrollInset(inset: UIEdgeInsets) {
        scrollView.contentInset = inset
    }

    func changeUIAppearing(type: SaveType) {
        switch type {
        case .all:
            emailView.changeBackground(color: .mainGray)
            [nameView, surnameView,
             fatherNameView, birthdayView,
             phoneView].forEach {
                $0.changeBackground(color: .white)
            }
            cancelChangesButton.isHidden = false
        case .email:
            [nameView, surnameView,
             fatherNameView, birthdayView,
             phoneView].forEach {
                $0.changeBackground(color: .mainGray)
            }
            emailView.changeBackground(color: .white)
            cancelChangesButton.isHidden = false
        case .default:
            [nameView, surnameView,
             fatherNameView, birthdayView,
             phoneView, emailView].forEach { $0.changeBackground(color: .white) }
            cancelChangesButton.isHidden = true
        }
    }

    // MARK: - Private methods

    @objc
    private func saveButtonAction() {
        delegate?.save()
    }

    @objc
    private func cancelEditingAction() {
        delegate?.cancelEditing()
    }

    @objc
    private func changeAllDataAction() {
        delegate?.changeAll()
    }

    @objc
    private func changeEmailAction() {
        delegate?.changeEmail()
    }

    @objc
    private func cancelChangesAction() {
        delegate?.cancelChanges()
    }
}

extension SettingsView {

    // MARK: - Instance methods

    private func setupSubviews() {
        backgroundColor = .mainGray

        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews(
            [stackView, changeUserDataButton, emailView,
             changeUserEmailButton, saveButton, cancelChangesButton]
        )

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.bottom.right.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.centerX.equalTo(scrollView)
            make.width.equalTo(scrollView)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).inset(20)
        }

        changeUserDataButton.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.right.equalTo(stackView)
        }

        emailView.snp.makeConstraints { make in
            make.top.equalTo(changeUserDataButton.snp.bottom).offset(30)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).inset(20)
            make.height.equalTo(48)
        }

        changeUserEmailButton.snp.makeConstraints { make in
            make.top.equalTo(emailView.snp.bottom).offset(10)
            make.right.equalTo(stackView)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(changeUserEmailButton.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(44)
        }

        cancelChangesButton.snp.makeConstraints { make in
            make.top.equalTo(saveButton.snp.bottom).offset(20)
            make.centerX.equalTo(saveButton)
            make.bottom.equalTo(contentView)
        }
    }

    private func setupRecognizer() {
        [self, contentView].forEach {
            $0.addGestureRecognizer(
                UITapGestureRecognizer(
                    target: self,
                    action: #selector(cancelEditingAction)
                )
            )
        }
    }

    private func setupTargets() {
        changeUserDataButton.addTarget(self, action: #selector(changeAllDataAction), for: .touchUpInside)
        changeUserEmailButton.addTarget(self, action: #selector(changeEmailAction), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
        cancelChangesButton.addTarget(self, action: #selector(cancelChangesAction), for: .touchUpInside)
    }
}
