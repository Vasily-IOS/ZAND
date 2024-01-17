//
//  AppleSignInView.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import UIKit
import SnapKit

protocol SignInDelegate: AnyObject {
    func signInButtonTap()
    func forgotButtonDidTap()
    func registerButtonDidTap()
    func cancelEditing()
    func setEmail(text: String)
    func setLogin(text: String)
}

final class SignInView: BaseUIView {

    // MARK: - Properties

    weak var delegate: SignInDelegate?

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = AssetString.entrance.rawValue
        return label
    }()

    private (set) var emailTextField = PaddingTextField(state: .email)

    private (set) var passwordTextField: PaddingTextField = {
        let textField = PaddingTextField(state: .password)
        textField.isSecureTextEntry = true
        return textField
    }()

    private lazy var mainStackView = UIStackView(
        alignment: .fill,
        arrangedSubviews: [
            emailTextField,
            passwordTextField
        ],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 30
    )

    private let forgotPassButton = TransparentButton(state: .forgotPassword)

    private let registerButton = TransparentButton(state: .register)

    private let signInButton = BottomButton(buttonText: .enter)

    private lazy var bottomStackView = UIStackView(
        alignment: .fill,
        arrangedSubviews: [
            registerButton,
            signInButton
        ],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 20
    )

    private let scrollView = UIScrollView()

    private let contentView = UIView()

    // MARK: - Instance methods

    override func setup() {
        setupSubviews()
        setupRecognizer()
        setupTargets()
        setupTextFieldHandlers()
    }

    func setNewScrollInset(inset: UIEdgeInsets) {
        scrollView.contentInset = inset
    }

    func setupUserInfo(model: UndeletableUserModel) {
        emailTextField.text = model.email
        passwordTextField.text = model.password
    }

    // MARK: - Private methods

    @objc
    private func signInAction() {
        delegate?.signInButtonTap()
    }

    @objc
    private func forgotPassAction() {
        delegate?.forgotButtonDidTap()
    }

    @objc
    private func registerAction() {
        delegate?.registerButtonDidTap()
    }

    @objc
    private func cancelEditingAction() {
        delegate?.cancelEditing()
    }
}

extension SignInView {

    // MARK: - Instance methods

    private func setupTextFieldHandlers() {
        emailTextField.textDidChange = { [weak self] email in
            self?.delegate?.setEmail(text: email)
        }

        passwordTextField.textDidChange = { [weak self] login in
            self?.delegate?.setLogin(text: login)
        }
    }

    private func setupSubviews() {
        backgroundColor = .mainGray

        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubviews([
            descriptionLabel,
            mainStackView,
            forgotPassButton,
            bottomStackView
        ])

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }

        contentView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(200)
            make.centerX.equalToSuperview()
        }

        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }

        forgotPassButton.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(10)
            make.right.equalTo(mainStackView.snp.right)
        }

        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(forgotPassButton.snp.bottom).offset(100)
            make.left.equalToSuperview().offset(40)
            make.right.equalToSuperview().inset(40)
            make.bottom.equalToSuperview().inset(30)
        }

        signInButton.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }

    private func setupTargets() {
        forgotPassButton.addTarget(self, action: #selector(forgotPassAction), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
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
