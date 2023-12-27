//
//  VerifyView.swift
//  ZAND
//
//  Created by Василий on 26.12.2023.
//

import UIKit
import SnapKit

protocol VerifyViewDelegate: AnyObject {
    func sendButtonDidTap()
    func cancelEditing()
}

final class VerifyView: BaseUIView {

    // MARK: - Properties

    weak var delegate: VerifyViewDelegate?

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.text = AssetString.confirmationCode.rawValue
        label.numberOfLines = 2
        return label
    }()

    private (set) var confirmationCodeTextField = PaddingTextField(state: .confirmation_code)

    private let sendButton = BottomButton(buttonText: .sendCode)

    // MARK: - Instance methods

    override func setup() {
        setupSubviews()
        setupTargets()
        setupRecognizer()
    }

    // MARK: - Action

    @objc
    private func sendButtonAction() {
        delegate?.sendButtonDidTap()
    }

    @objc
    private func cancelEditingAction() {
        delegate?.cancelEditing()
    }
}

extension VerifyView {

    // MARK: - Instance methods

    private func setupSubviews() {
        backgroundColor = .mainGray

        addSubviews([descriptionLabel, confirmationCodeTextField, sendButton])

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(200)
            make.centerX.equalToSuperview()
        }

        confirmationCodeTextField.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }

        sendButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(30)
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
