//
//  RefreshPasswordView.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

import UIKit
import SnapKit

protocol RefreshPasswordDelegate: AnyObject {
    func refreshButtonDidTap()
    func cancelEditing()
    func setPassword(text: String)
    func setRepeatPassword(text: String)
    func setVerifyCode(text: String)
}

final class RefreshPasswordView: BaseUIView {

    // MARK: - Properties

    weak var delegate: RefreshPasswordDelegate?

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = AssetString.resetPassword.rawValue
        label.numberOfLines = 2
        return label
    }()

    private (set) var passwordTextField: PaddingTextField = {
        let textField = PaddingTextField(state: .password)
        textField.isSecureTextEntry = true
        return textField
    }()

    private (set) var repeatPasswordTextField: PaddingTextField = {
        let textField = PaddingTextField(state: .confirmPassword)
        textField.isSecureTextEntry = true
        return textField
    }()

    private (set) var verifyCodeTextField = PaddingTextField(state: .confirmation_code)

    private lazy var mainStackView = UIStackView(
        alignment: .fill,
        arrangedSubviews: [
            passwordTextField,
            repeatPasswordTextField,
            verifyCodeTextField
        ],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 30
    )

    private let refreshPasswordButton = BottomButton(buttonText: .refreshPassword)

    // MARK: - Instance methods

    override func setup() {
        setupSubviews()
        setupTargets()
        setupRecognizer()
        setupTextFieldHandlers()
    }

    // MARK: - Action

    @objc
    private func refreshButtonAction() {
        delegate?.refreshButtonDidTap()
    }

    @objc
    private func cancelEditingAction() {
        delegate?.cancelEditing()
    }
}

extension RefreshPasswordView {

    // MARK: - Instance methods

    private func setupTextFieldHandlers() {
        passwordTextField.textDidChange = { [weak self] text in
            self?.delegate?.setPassword(text: text)
        }

        repeatPasswordTextField.textDidChange = { [weak self] text in
            self?.delegate?.setRepeatPassword(text: text)
        }

        verifyCodeTextField.textDidChange = { [weak self] text in
            self?.delegate?.setVerifyCode(text: text)
        }
    }

    private func setupSubviews() {
        backgroundColor = .mainGray

        addSubviews([descriptionLabel, mainStackView, refreshPasswordButton])

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(200)
            make.centerX.equalToSuperview()
        }

        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }

        refreshPasswordButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(30)
        }
    }

    private func setupTargets() {
        refreshPasswordButton.addTarget(self, action: #selector(refreshButtonAction), for: .touchUpInside)
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
