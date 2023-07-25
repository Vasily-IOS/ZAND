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
    func signIn()
}

final class SignInView: BaseUIView {
    
    // MARK: - Properties

    weak var delegate: SignInDelegate?

    let nameTextField = PaddingTextField(state: .name)

    let phoneTextField = PaddingTextField(state: .phone)

    let smsCodeTextField = PaddingTextField(state: .smsCode)

    private let signInLabel = UILabel(.systemFont(ofSize: 20, weight: .bold),
                                      .black,
                                      AssetString.entrance)

    private lazy var entranceStackView = UIStackView(alignment: .fill,
                                                     arrangedSubviews: [
                                                        nameTextField,
                                                        phoneTextField,
                                                        smsCodeTextField
                                                     ],
                                                     axis: .vertical,
                                                     distribution: .fill,
                                                     spacing: 20)

    private let signInButton = BottomButton(buttonText: .contin)

    private lazy var bottomButtonsStackView = UIStackView(alignment: .center,
                                                      arrangedSubviews: [
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

        smsCodeTextField.resignFirstResponder()
        smsCodeTextField.isHidden = true
    }

    func updateUI() {
        nameTextField.isHidden = true
        phoneTextField.isHidden = true
        smsCodeTextField.isHidden = false

        signInButton.stateText = .enter
    }

    func initialStartMode() {
        nameTextField.isHidden = false
        phoneTextField.isHidden = false
        smsCodeTextField.isHidden = true

        signInButton.stateText = .contin
    }

    func hideKeyboard() {
        phoneTextField.resignFirstResponder()
    }
    
    // MARK: - Action
    
    @objc
    private func dismissKeyboard() {
        delegate?.stopEditing()
    } 
    
    @objc
    private func signInAction() {
        delegate?.signIn()
    }
}

extension SignInView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        backgroundColor = .mainGray

        addSubviews([signInLabel, entranceStackView, bottomButtonsStackView])
        
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
    }
    
    private func setRecognizer() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    private func addTargets() {
        signInButton.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
    }
}
