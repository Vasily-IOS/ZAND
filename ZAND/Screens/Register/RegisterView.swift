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
    func updateTo(state: RegistrationState)
}

final class RegisterView: BaseUIView {
    
    // MARK: - Properties

    var state: RegistrationState? {
        didSet {
            guard let state else { return }

            if state == .thirdStep {
                bottomButton.stateText = .register
                registerLabel.text = StringsAsset.confirmEmail
            }
        }
    }
    
    weak var delegate: RegisterViewDelegate?

    // MARK: - UI

    lazy var entranceStackView = UIStackView(alignment: .fill,
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

    lazy var bottomButtonsStackView = UIStackView(alignment: .center,
                                                      arrangedSubviews: [
                                                        transparentButton,
                                                        bottomButton,
                                                        skipButton
                                                      ],
                                                      axis: .vertical,
                                                      distribution: .fill,
                                                      spacing: 10)
    
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
    private func backToSignInAction() {
        delegate?.popViewController()
    }
    
    @objc
    private func registerButtonAction() {
        guard let state else { return }

        if state == .firstStep {
            delegate?.updateTo(state: .secondStep)
        } else if state == .secondStep {
            delegate?.updateTo(state: .thirdStep)
        }
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
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    private func addTargets() {
        transparentButton.addTarget(self,
                                    action: #selector(backToSignInAction),
                                    for: .touchUpInside)

        bottomButton.addTarget(self,
                               action: #selector(registerButtonAction),
                               for: .touchUpInside)

        skipButton.addTarget(self,
                             action: #selector(skipAction),
                             for: .touchUpInside)
    }
}
