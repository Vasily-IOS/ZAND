//
//  RegisterNView.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import UIKit
import SnapKit

protocol RegisterNDelegate: AnyObject {
    func cancelEditing()
}

final class RegisterNView: BaseUIView {

    // MARK: - Properties

    weak var delegate: RegisterNDelegate?

    private let registerLabel = UILabel(
        .systemFont(ofSize: 24, weight: .bold),
        .black,
        AssetString.registation
    )

    private let nameTextField = PaddingTextField(state: .name)

    private let surnameTextField = PaddingTextField(state: .surname)

    private let emailTextField = PaddingTextField(state: .email)

    private let phoneTextField = PaddingTextField(state: .phone)

    private let registerButton = BottomButton(buttonText: .register)

    private lazy var interiorStackView = UIStackView(
        alignment: .center,
        arrangedSubviews: [nameTextField,
                           surnameTextField,
                           emailTextField,
                           phoneTextField],
        axis: .vertical,
        distribution: .fill,
        spacing: 16
    )

    private lazy var baseStackView = UIStackView(
        alignment: .center,
        arrangedSubviews: [registerLabel,
                           interiorStackView],
        axis: .vertical,
        distribution: .fill,
        spacing: 30)

    // MARK: - Instance methods

    override func setup() {
        super.setup()

        setViews()
        setRecognizer()
    }

    // MARK: - Action

    @objc
    private func cancelEditingAction() {
        delegate?.cancelEditing()
    }
}

extension RegisterNView {

    // MARK: - Instance methods

    private func setViews() {
        backgroundColor = .mainGray

        addSubviews([baseStackView, registerButton])

        [nameTextField, surnameTextField, emailTextField, phoneTextField].forEach {
            $0.snp.makeConstraints { make in
                make.left.equalTo(self.snp.left).offset(16)
                make.right.equalTo(self.snp.right).inset(16)
            }
        }

        baseStackView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(200)
            make.centerX.equalToSuperview()
        }

        registerButton.snp.makeConstraints { make in
            make.top.equalTo(baseStackView.snp.bottom).offset(60)
            make.width.equalTo(interiorStackView)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
        }
    }

    private func setRecognizer() {
        addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(cancelEditingAction)
            )
        )
    }
}
