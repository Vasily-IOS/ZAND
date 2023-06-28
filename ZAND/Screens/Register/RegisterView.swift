//
//  RegisterView.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit

protocol RegisterViewDelegate: AnyObject {
    func skip()
}

final class RegisterView: BaseUIView {
    
    // MARK: - Nested types
    
    enum RegistrationSteps {
        case one
        case two
        case three
    }
    
    // MARK: -
    
    weak var delegate: RegisterViewDelegate?
    
    var registerState: RegistrationSteps = .one {
        didSet {
            updateUI(by: registerState)
        }
    }
    
    // MARK: - UI
    
    private let registerLabel = UILabel(.systemFont(ofSize: 20, weight: .bold),
                                        .black,
                                        StringsAsset.registation)

    private let nameTextField = PaddingTextField(state: .name)

    private let surnameTextField = PaddingTextField(state: .surname)

    private let ageTextField = PaddingTextField(state: .age)
    
    private let userNameTextField = PaddingTextField(state: .usename)

    private let emailTextField = PaddingTextField(state: .email)

    private let passwordTextField = PaddingTextField(state: .password)

    private let confirmPasswordTextField = PaddingTextField(state: .confirmPassword)
    
    private let confirmationCodeTextField = PaddingTextField(state: .confirmation_code)
    
    private let transparentButton = TransparentButton(state: .accountExist)
    private lazy var entranceStackView = UIStackView(alignment: .fill,
                                                     arrangedSubviews: [
                                                        nameTextField,
                                                        surnameTextField,
                                                        ageTextField,
                                                        userNameTextField,
                                                        emailTextField,
                                                        passwordTextField,
                                                        confirmPasswordTextField,
                                                        confirmationCodeTextField
                                                     ],
                                                     axis: .vertical,
                                                     distribution: .fill,
                                                     spacing: 10)

    private let bottomButton = BottomButton(buttonText: .contin)

    private let skipButton: UIButton = {
        let skipButton = UIButton()
        skipButton.layer.borderColor = UIColor.lightGreen.cgColor
        skipButton.layer.borderWidth = 1
        skipButton.backgroundColor = .mainGray
        skipButton.setTitle(StringsAsset.skip, for: .normal)
        skipButton.setTitleColor(.mainGreen, for: .normal)
        skipButton.layer.cornerRadius = 15
        skipButton.isHidden = !OnboardManager.shared.isUserFirstLaunch()
        return skipButton
    }()

    private lazy var bottomButtonsStackView = UIStackView(alignment: .center,
                                                      arrangedSubviews: [
                                                        transparentButton,
                                                        bottomButton,
                                                        skipButton
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
        setInitialRegistrationStep()
    }
    
    // MARK: - Action
    
    @objc
    private func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc
    private func backToSignInAction() {
        AppRouter.shared.popViewController()
    }
    
    @objc
    private func bottomButtonAction() {
        if registerState == .one {
            registerState = .two
        } else if registerState == .two {
            registerState = .three
            bottomButton.stateText = .register
            registerLabel.text = StringsAsset.confirmEmail
        }
    }
    
    @objc
    private func skipAction() {
        delegate?.skip()
    }
    
    // MARK: - Registration steps
    
    private func updateUI(by state: RegistrationSteps) {
        switch state {
        case .one:
            entranceStackView.subviews.suffix(5).forEach {
                $0.isHidden = true
            }
        case .two:
            let range = 3..<7
            for i in 0..<entranceStackView.subviews.count {
                if range.contains(i) {
                    entranceStackView.subviews[i].isHidden = false
                } else {
                    entranceStackView.subviews[i].isHidden = true
                }
            }
        case .three:
            entranceStackView.subviews.prefix(8).forEach {
                $0.isHidden = true
            }
            entranceStackView.subviews.suffix(1).forEach {
                $0.isHidden = false
            }
        }
    }
}

extension RegisterView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        backgroundColor = .mainGray

        addSubviews([registerLabel, entranceStackView,
                     bottomButtonsStackView])
        
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
        
        bottomButton.snp.makeConstraints { make in
            make.width.equalTo(280)
            make.height.equalTo(44)
        }
        
        skipButton.snp.makeConstraints { make in
            make.width.height.equalTo(bottomButton)
        }
    }
    
    private func setRecognizer() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(recognizer)
    }
    
    private func addTargets() {
        transparentButton.addTarget(self, action: #selector(backToSignInAction), for: .touchUpInside)
        bottomButton.addTarget(self, action: #selector(bottomButtonAction), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
    }
    
    private func setInitialRegistrationStep() {
        registerState = .one
    }
}
