//
//  SignInView.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit
import SnapKit

protocol SignInDelegate: AnyObject {
    func stopEditing()
    func navigateToRegister()
    func navigatetoProfile()
}

final class SignInView: BaseUIView {
    
    // MARK: - Properties

    weak var delegate: SignInDelegate?
    
    private let signInLabel = UILabel(.systemFont(ofSize: 20, weight: .bold),
                                      .black,
                                      StringsAsset.entrance)

    private let emailTextField = PaddingTextField(state: .email)

    private let passTextField = PaddingTextField(state: .password)

    private let transparentButton = TransparentButton(state: .forgotPassword)
    
    private lazy var entranceStackView = UIStackView(alignment: .fill,
                                                     arrangedSubviews: [
                                                        emailTextField,
                                                        passTextField
                                                     ],
                                                     axis: .vertical,
                                                     distribution: .fill,
                                                     spacing: 10)

    private let registerButton = TransparentButton(state: .register)

    private let signInButton = BottomButton(buttonText: .enter)

    private lazy var bottomButtonsStackView = UIStackView(alignment: .center,
                                                      arrangedSubviews: [
                                                        registerButton,
                                                        signInButton
                                                      ],
                                                      axis: .vertical,
                                                      distribution: .fill,
                                                      spacing: 10)

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
        setRecognizer()
        addTargets()
    }
    
    // MARK: - Action
    
    @objc
    private func dismissKeyboard() {
        delegate?.stopEditing()
    }
    
    @objc
    private func navigateToRegisterAction() {
        delegate?.navigateToRegister()
    }
    
    @objc
    private func navigateToProfileAction() {
        delegate?.navigatetoProfile()
    }
}

extension SignInView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        backgroundColor = .mainGray

        addSubviews([signInLabel, entranceStackView,
                     bottomButtonsStackView, transparentButton])
        
        signInLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(200)
            make.centerX.equalTo(self)
        }
        
        entranceStackView.snp.makeConstraints { make in
            make.top.equalTo(signInLabel.snp.bottom).offset(30)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
            
        }
        
        bottomButtonsStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self).inset(120)
            make.centerX.equalTo(self)
        }
        
        signInButton.snp.makeConstraints { make in
            make.width.equalTo(280)
            make.height.equalTo(44)
        }
        
        transparentButton.snp.makeConstraints { make in
            make.right.equalTo(entranceStackView.snp.right)
            make.top.equalTo(entranceStackView.snp.bottom).offset(14)
        }
    }
    
    private func setRecognizer() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    private func addTargets() {
        signInButton.addTarget(self, action: #selector(navigateToProfileAction), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(navigateToRegisterAction), for: .touchUpInside)
    }
}
