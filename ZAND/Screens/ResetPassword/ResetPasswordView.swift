//
//  ResetPasswordView.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

import UIKit
import SnapKit

protocol ResetPasswordDelegate: AnyObject {
    func resetPasswordButtonDidTap()
    func cancelEditing()
    func setEmail(text: String)
}

final class ResetPasswordView: BaseUIView {

    // MARK: - Properties

    weak var delegate: ResetPasswordDelegate?

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = AssetString.resetPassword.rawValue
        label.numberOfLines = 2
        return label
    }()

    private (set) var emailTextField = PaddingTextField(state: .email)

    private lazy var mainStackView = UIStackView(
        alignment: .fill,
        arrangedSubviews: [
            emailTextField
        ],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 30
    )

    private let sendButton = BottomButton(buttonText: .getCode)

    // MARK: - Instance methods

    override func setup() {
        setupSubviews()
        setupTargets()
        setupRecognizer()
        setupTextFieldHandlers()
    }

    func disableButtonСlicking() {
        sendButton.isUserInteractionEnabled = false
    }

    // MARK: - Action

    @objc
    private func sendButtonAction() {
        delegate?.resetPasswordButtonDidTap()
    }

    @objc
    private func cancelEditingAction() {
        delegate?.cancelEditing()
    }
}

extension ResetPasswordView {

    // MARK: - Instance methods

    private func setupTextFieldHandlers() {
        emailTextField.textDidChange = { [weak self] text in
            self?.delegate?.setEmail(text: text)
        }
    }

    private func setupSubviews() {
        backgroundColor = .mainGray

        addSubviews([descriptionLabel, mainStackView, sendButton])

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(200)
            make.centerX.equalToSuperview()
        }

        mainStackView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }

        sendButton.snp.makeConstraints { make in
            make.top.equalTo(mainStackView.snp.bottom).offset(40)
            make.height.equalTo(44)
            make.width.equalTo(mainStackView)
            make.centerX.equalTo(mainStackView)
        }
    }

    private func setupTargets() {
        sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
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
