//
//  ViewOnMapButton.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit

final class TransparentButton: UIButton {
    
    // MARK: - Nested types
    
    enum State {
        case viewOnMap
        case register
        case forgotPassword
        case accountExist
        case changeUserData
        case changeUserEmail
        
        var fontSize: CGFloat {
            switch self {
            case .viewOnMap, .forgotPassword, .accountExist, .changeUserData, .changeUserEmail:
                return 12.0
            case .register:
                return 16.0
            }
        }
        
        var text: String {
            switch self {
            case .viewOnMap:
                return AssetString.viewOnMap.rawValue
            case .register:
                return AssetString.register.rawValue
            case .forgotPassword:
                return AssetString.forgotPassword.rawValue
            case .accountExist:
                return AssetString.accountExist.rawValue
            case .changeUserData:
                return AssetString.changeUserData.rawValue
            case .changeUserEmail:
                return AssetString.changeUserEmail.rawValue
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .viewOnMap, .forgotPassword, .changeUserData, .changeUserEmail:
                return .lightGreen
            case .register:
                return .mainGreen
            case .accountExist:
                return .textGray
            }
        }
    }
    
    // MARK: - Initializers
    
    init(state: State) {
        super.init(frame: .zero)
        setup(with: state)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TransparentButton {
    
    // MARK: - Instance methods
    
    private func setup(with state: State) {
        setTitle(state.text, for: .normal)
        setTitleColor(state.textColor, for: .normal)
        titleLabel?.font = .systemFont(ofSize: state.fontSize)
    }
}
