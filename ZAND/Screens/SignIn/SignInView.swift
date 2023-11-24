//
//  AppleSignInView.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import UIKit
import SnapKit
import AuthenticationServices

protocol SignInDelegate: AnyObject {
    func signInButtonTap()
}

final class SignInView: BaseUIView {

    // MARK: - Properties

    weak var delegate: SignInDelegate?

    private let topLabel = UILabel(
        .systemFont(ofSize: 24, weight: .bold),
        .black,
        AssetString.youIsNotRegister.rawValue
    )

    private let mediumLabel = UILabel(
        .systemFont(ofSize: 16, weight: .regular),
        .black,
        AssetString.pleaseRegister.rawValue)

    private let appleButton = ASAuthorizationAppleIDButton()

    private lazy var stackView = UIStackView(
        alignment: .center,
        arrangedSubviews: [topLabel, mediumLabel, appleButton],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 60
    )

    // MARK: - Instance methods

    override func setup() {
        super.setup()

        setViews()
        addTargets()
    }

    // MARK: - Action

    @objc
    private func signInAction() {
        delegate?.signInButtonTap()
    }
}

extension SignInView {

    // MARK: - Instance methods

    private func setViews() {
        addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        appleButton.snp.makeConstraints { make in
            make.width.equalTo(mediumLabel)
            make.height.equalTo(50)
        }
    }

    private func addTargets() {
        appleButton.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
    }
}
