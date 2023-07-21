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
        case smsCode
        case name
        case surname
        case age
        case usename
        case confirmPassword
        case confirmation_code
        case phone
        
        var placeholder_text: String {
            switch self {
            case .email:
                return AssetString.email
            case .smsCode:
                return AssetString.smsCode
            case .name:
                return AssetString.name
            case .surname:
                return AssetString.surname
            case .age:
                return AssetString.age
            case .usename:
                return AssetString.userName
            case .confirmPassword:
                return AssetString.confirmPassword
            case .confirmation_code:
                return AssetString.confirmationCode
            case .phone:
                return AssetString.phoneNumber
            }
        }
    }
    
    // MARK: - Properties
    
    var textPadding = UIEdgeInsets(
        top: 0,
        left: 10,
        bottom: 0,
        right: 10
    )
    
    // MARK: - Initializers
    
    init(state: State) {
        super.init(frame: .zero)

        setSelf()
        setup(with: state)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -
    
    private func setup(with state: State) {
        placeholder = state.placeholder_text

        if state == .phone || state == .smsCode {
            keyboardType = .numberPad
        }
    }
    
    private func setSelf() {
        layer.cornerRadius = 15.0
        backgroundColor = .white
        self.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
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
