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
    func setBirthday(date: Date)
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

    private let datePicker = UIDatePicker()

    // MARK: - Instance methods

    override func setup() {
        setupSubviews()
        setupRecognizer()
        setupTargets()
        createDatePicker()

        getAllTextFields().forEach { $0.isUserInteractionEnabled = false }
    }

    func configure(model: UserDataBaseModel) {
        nameView.setText(text: model.name)
        surnameView.setText(text: model.surname)
        fatherNameView.setText(text: model.fathersName)
        phoneView.setText(text: model.phone)
        emailView.setText(text: model.email)

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFromString = dateFormatter.date(from: model.birthday)
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "dd MMMM yyyy"
        newFormatter.locale = Locale(identifier: "ru_RU")
        birthdayView.textField.text = newFormatter.string(from: dateFromString ?? Date())
    }

    func setNewScrollInset(inset: UIEdgeInsets) {
        scrollView.contentInset = inset
    }

    func changeUIAppearing(type: SaveType) {
        switch type {
        case .all:
            emailView.changeBackground(color: .mainGray)
            emailView.textField.isUserInteractionEnabled = false
            [nameView, surnameView,
             fatherNameView, birthdayView,
             phoneView].forEach {
                $0.changeBackground(color: .white)
                $0.textField.isUserInteractionEnabled = true
            }
            cancelChangesButton.isHidden = false
        case .email:
            [nameView, surnameView,
             fatherNameView, birthdayView,
             phoneView].forEach {
                $0.changeBackground(color: .mainGray)
                $0.textField.isUserInteractionEnabled = false
            }
            emailView.changeBackground(color: .white)
            emailView.textField.isUserInteractionEnabled = true
            cancelChangesButton.isHidden = false
        case .default:
            [nameView, surnameView,
             fatherNameView, birthdayView,
             phoneView, emailView].forEach { $0.changeBackground(color: .white) }
            cancelChangesButton.isHidden = true
            getAllTextFields().forEach { $0.isUserInteractionEnabled = false }
        }
    }

    func getAllTextFields() -> [UITextField] {
        [nameView.textField,
         surnameView.textField,
         fatherNameView.textField,
         birthdayView.textField,
         phoneView.textField,
         emailView.textField]
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

    @objc
    private func pickerDoneAction() {
        setDate()
    }

    private func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()

        let spaceButton = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace,
            target: nil,
            action: nil
        )
        let doneButton = UIBarButtonItem(
            title: AssetString.done.rawValue,
            style: .plain,
            target: self,
            action: #selector(pickerDoneAction)
        )
        toolBar.setItems([spaceButton, doneButton], animated: true)

        return toolBar
    }

    private func createDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.maximumDate = Date()
        datePicker.locale = Locale(identifier: "ru_RU")
        birthdayView.textField.inputView = datePicker
        birthdayView.textField.inputAccessoryView = createToolBar()
    }

    private func setDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        birthdayView.textField.text = dateFormatter.string(from: datePicker.date)
        delegate?.setBirthday(date: datePicker.date)
        birthdayView.textField.resignFirstResponder()
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
