//
//  PaddingTextField.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit
import SnapKit

final class PaddingTextField: UITextField {
    
    // MARK: - Nested types
    
    enum State {
        case email
        case password
        case smsCode
        case name // имя
        case surname // фамилия
        case fathersName // отчество
        case age
        case usename
        case createPassword
        case confirmPassword
        case confirmation_code
        case phone
        case birthday
        case repeatPassword
        case phoneEnter
        
        var placeholder_text: String {
            switch self {
            case .email:
                return AssetString.email.rawValue
            case .password:
                return AssetString.password.rawValue
            case .smsCode:
                return AssetString.smsCode.rawValue
            case .name:
                return AssetString.name.rawValue
            case .surname:
                return AssetString.surname.rawValue
            case .fathersName:
                return AssetString.fathersName.rawValue
            case .age:
                return AssetString.age.rawValue
            case .usename:
                return AssetString.userName.rawValue
            case .createPassword:
                return AssetString.createPassword.rawValue
            case .confirmPassword:
                return AssetString.confirmPassword.rawValue
            case .confirmation_code:
                return AssetString.confirmationCode.rawValue
            case .phone:
                return AssetString.phoneNumber.rawValue
            case .birthday:
                return AssetString.birthday.rawValue
            case .repeatPassword:
                return AssetString.repeatPassword.rawValue
            case .phoneEnter:
                return AssetString.phoneEnter.rawValue
            }
        }
    }
    
    // MARK: - Properties

    var textDidChange: ((String) -> Void)?
    
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 10,
        bottom: 0,
        right: 10
    )

    // MARK: - Initializers

    init(state: State) {
        super.init(frame: .zero)
        
        setup(state: state)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -

    private func setup(state: State) {
        layer.cornerRadius = 15.0
        backgroundColor = .white
        addTarget(self, action: #selector(textDidChange(_:)), for: .editingChanged)
        placeholder = state.placeholder_text

        if state == .phone || state == .smsCode {
            keyboardType = .numberPad
        }

        self.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }

    @objc
    private func textDidChange(_ sender: UITextField) {
//        if sender.text == "" {
//            layer.borderWidth = 0.5
//            layer.borderColor = UIColor.red.cgColor
//        } else {
//            layer.borderWidth = 0
//        }

        textDidChange?(sender.text ?? "")
    }
    
    // MARK: - UITextField Methods
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: textPadding)
    }
}
