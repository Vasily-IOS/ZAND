//
//  RegisterView.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import UIKit
import SnapKit

protocol RegisterDelegate: AnyObject {
    func cancelEditing()
    func register()
    func showPolicy()
    func changePolicy(isConfirmed: Bool)
    func setBirthday(birthday: Date)
}

final class RegisterView: BaseUIView {

    // MARK: - Properties

    weak var delegate: RegisterDelegate?

    private (set) var nameTextField = PaddingTextField(state: .name)

    private (set) var surnameTextField = PaddingTextField(state: .surname)

    private (set) var fathersNameTextField = PaddingTextField(state: .fathersName) // отчество не обязательно

    private (set) var birthdayTextField = PaddingTextField(state: .birthday) // birthday не обязательно

    private (set) var emailTextField = PaddingTextField(state: .email)

    private (set) var phoneTextField: PaddingTextField = {
        let phoneTextField = PaddingTextField(state: .phone)
        phoneTextField.layer.borderColor = UIColor.red.cgColor
        phoneTextField.layer.borderWidth = 0.0
        phoneTextField.text = AssetString.phoneEnter.rawValue
        return phoneTextField
    }()

    private (set) var createPasswordTextField: PaddingTextField = {
        let textField = PaddingTextField(state: .createPassword)
        textField.isSecureTextEntry = true
        return textField
    }()

    private (set) var repeatPasswordTextField: PaddingTextField = {
        let textField = PaddingTextField(state: .repeatPassword)
        textField.isSecureTextEntry = true
        return textField
    }()

    private let policySwitchControl = UISwitch()

    private let agreeButton: UIButton = {
        let policyButton = UIButton()
        policyButton.setTitle("Согласен с", for: .normal)
        policyButton.setTitleColor(.black, for: .normal)
        policyButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        return policyButton
    }()

    private let policyButton: UIButton = {
        let policyButton = UIButton()

        let attributes: [NSAttributedString.Key: Any] = [
              .font: UIFont.systemFont(ofSize: 12),
              .foregroundColor: UIColor.mainGreen,
              .underlineStyle: NSUnderlineStyle.single.rawValue
          ]

        let attributeString = NSMutableAttributedString(
                string: "политикой конфиденциальности",
                attributes: attributes
             )

        policyButton.setAttributedTitle(attributeString, for: .normal)
        return policyButton
    }()

    private let continueButton = BottomButton(buttonText: .contin)

    private let entranceLabel = UILabel(
        .systemFont(ofSize: 24, weight: .bold),
        .black,
        AssetString.registation.rawValue
    )

    private lazy var policyButtonsStackView = UIStackView(
        alignment: .leading,
        arrangedSubviews: [agreeButton, policyButton],
        axis: .vertical,
        distribution: .fillProportionally
    )

    private lazy var textFieldsStackView = UIStackView(
        alignment: .fill,
        arrangedSubviews: [
            nameTextField,
            surnameTextField,
            fathersNameTextField,
            birthdayTextField,
            emailTextField,
            phoneTextField,
            createPasswordTextField,
            repeatPasswordTextField
        ],
        axis: .vertical,
        distribution: .fillProportionally,
        spacing: 16
    )

    private lazy var policyStackView = UIStackView(
        alignment: .leading,
        arrangedSubviews: [
            policyButtonsStackView,
            policySwitchControl
        ],
        axis: .horizontal,
        spacing: 5
    )

    private let scrollView = UIScrollView()

    private let contentView = UIView()

    private let datePicker = UIDatePicker()

    // MARK: - Instance methods

    override func setup() {
        setupSubviews()
        setupRecognizer()
        setupTargets()
        createDatePicker()
    }

    func hidePhoneKeyboard() {
        phoneTextField.resignFirstResponder()
    }

    func makeRedBorder() {
        phoneTextField.layer.borderColor = UIColor.red.cgColor
        phoneTextField.layer.borderWidth = 0.5
    }

    func removeBorder() {
        phoneTextField.layer.borderWidth = 0.0
    }

    func setNewScrollInset(inset: UIEdgeInsets) {
        scrollView.contentInset = inset
    }

    func getAllTextFileds() -> [UITextField] {
        [nameTextField,
         surnameTextField,
         fathersNameTextField,
         birthdayTextField,
         emailTextField,
         phoneTextField,
         createPasswordTextField,
         repeatPasswordTextField
        ]
    }
    
    // MARK: - Private methods

    @objc
    private func cancelEditingAction() {
        delegate?.cancelEditing()
    }

    @objc
    private func registerAction() {
        delegate?.register()
    }

    @objc
    private func openPolicyAction() {
        delegate?.showPolicy()
    }

    @objc
    private func switchAction(_ sender: UISwitch) {
        delegate?.changePolicy(isConfirmed: sender.isOn)
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
        birthdayTextField.inputView = datePicker
        birthdayTextField.inputAccessoryView = createToolBar()
    }

    private func setDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        birthdayTextField.text = dateFormatter.string(from: datePicker.date)
        delegate?.setBirthday(birthday: datePicker.date)
        birthdayTextField.resignFirstResponder()
    }
}

extension RegisterView {

    // MARK: - Instance methods

    private func setupSubviews() {
        backgroundColor = .mainGray

        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubviews([
            entranceLabel,
            textFieldsStackView,
            policyStackView,
            continueButton
        ])

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.bottom.right.equalToSuperview()
        }

        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }

        entranceLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(30)
            make.centerX.equalToSuperview()
        }

        textFieldsStackView.snp.makeConstraints { make in
            make.top.equalTo(entranceLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }

        policyStackView.snp.makeConstraints { make in
            make.top.equalTo(textFieldsStackView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }

        continueButton.snp.makeConstraints { make in
            make.top.equalTo(policyStackView.snp.bottom).offset(30)
            make.width.equalTo(textFieldsStackView)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(40).priority(999)
        }
    }

    private func setupTargets() {
        continueButton.addTarget(
            self,
            action: #selector(registerAction),
            for: .touchUpInside
        )

        policyButton.addTarget(
            self,
            action: #selector(openPolicyAction),
            for: .touchUpInside
        )

        policySwitchControl.addTarget(
            self,
            action: #selector(switchAction),
            for: .valueChanged
        )
    }

    private func setupRecognizer() {
        addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(cancelEditingAction)
            )
        )
    }
}
