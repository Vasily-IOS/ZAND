//
//  RegisterView.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit

protocol RegisterViewDelegate: AnyObject {
    func skip()
    func popViewController()
    func stopEditing()
    func register()
}

final class RegisterView: BaseUIView {
    
    // MARK: - Properties
    
    weak var delegate: RegisterViewDelegate?

    // MARK: - UI

    lazy var entranceStackView = UIStackView(
        alignment: .fill,
        arrangedSubviews: [
            phoneTextField,
            smsCodeTextField
        ],
        axis: .vertical,
        distribution: .fill,
        spacing: 20
    )

    lazy var bottomButtonsStackView = UIStackView(
        alignment: .center,
        arrangedSubviews: [
            transparentButton,
            registerButton,
            skipButton
        ],
        axis: .vertical,
        distribution: .fill,
        spacing: 10
    )

    let nameTextField = PaddingTextField(state: .name)

    let emailTextField = PaddingTextField(state: .email)

    let smsCodeTextField = PaddingTextField(state: .smsCode)

    let phoneTextField: PaddingTextField = {
        let phoneTextField = PaddingTextField(state: .phone)
        phoneTextField.text = "+7"
        return phoneTextField
    }()

    private let registerLabel = UILabel(.systemFont(ofSize: 20, weight: .bold),
                                        .black,
                                        AssetString.registation)

    private let transparentButton = TransparentButton(state: .accountExist)

    private var registerButton = BottomButton(buttonText: .getCode)

    private let skipButton: UIButton = {
        let skipButton = UIButton()
        skipButton.layer.borderColor = UIColor.lightGreen.cgColor
        skipButton.layer.borderWidth = 1
        skipButton.backgroundColor = .mainGray
        skipButton.setTitle(AssetString.skip, for: .normal)
        skipButton.setTitleColor(.mainGreen, for: .normal)
        skipButton.layer.cornerRadius = 15
//        skipButton.isHidden = !OnboardManager.shared.isUserFirstLaunch()
        skipButton.isHidden = true
        return skipButton
    }()

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
        setRecognizer()
        addTargets()
    }

    func updateUI() {
        smsCodeTextField.isHidden = false
        nameTextField.isHidden = true
        registerButton.stateText = .register
    }

    func hidePhoneKeyboard() {
        phoneTextField.resignFirstResponder()
    }
    
    // MARK: - Action
    
    @objc
    private func dismissKeyboard() {
        delegate?.stopEditing()
    }
    
    @objc
    private func backToSignInAction() {
        delegate?.popViewController()
    }
    
    @objc
    private func registerButtonAction() {
        delegate?.register()
    }
    
    @objc
    private func skipAction() {
        delegate?.skip()
    }
}

extension RegisterView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        backgroundColor = .mainGray

        addSubviews([registerLabel, entranceStackView, bottomButtonsStackView])
        registerLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(200)
            make.centerX.equalTo(self)
        }
        
        entranceStackView.snp.makeConstraints { make in
            make.top.equalTo(registerLabel.snp.bottom).offset(30)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
        }
        
        bottomButtonsStackView.snp.makeConstraints { make in
            make.bottom.equalTo(self).inset(120)
            make.centerX.equalTo(self)
        }
        
        registerButton.snp.makeConstraints { make in
            make.width.equalTo(280)
            make.height.equalTo(44)
        }
        
        skipButton.snp.makeConstraints { make in
            make.width.height.equalTo(registerButton)
        }
    }
    
    private func setRecognizer() {
        addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                    action: #selector(dismissKeyboard)))
    }
    
    private func addTargets() {
        transparentButton.addTarget(self,
                                    action: #selector(backToSignInAction),
                                    for: .touchUpInside)

        registerButton.addTarget(self,
                               action: #selector(registerButtonAction),
                               for: .touchUpInside)

        skipButton.addTarget(self,
                             action: #selector(skipAction),
                             for: .touchUpInside)
    }
}
