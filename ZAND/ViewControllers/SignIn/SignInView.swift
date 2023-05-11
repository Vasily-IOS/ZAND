//
//  SignInView.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit
import SnapKit

final class SignInView: BaseUIView {
    
    // MARK: - Properties
    
    private let signInLabel = UILabel(.systemFont(ofSize: 20, weight: .bold), .black, Strings.entrance)
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
        setBackgroundColor()
        setViews()
        setRecognizer()
        addTargets()
    }
    
    // MARK: - Action
    
    @objc
    private func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc
    private func registerAction() {
        AppRouter.shared.push(.register)
    }
    
    @objc
    private func signInAction() {
        AppRouter.shared.push(.profile)
    }
}

extension SignInView {
    
    // MARK: - Instance methods
    
    private func setViews() {
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
    
    private func setBackgroundColor() {
        backgroundColor = .mainGray
    }
    
    private func setRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(recognizer)
    }
    
    private func addTargets() {
        signInButton.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(registerAction), for: .touchUpInside)
    }
}
