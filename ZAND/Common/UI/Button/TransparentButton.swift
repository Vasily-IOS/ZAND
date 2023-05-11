//
//  ViewOnMapButton.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit

class TransparentButton: UIButton {
    
    // MARK: - Nested types
    
    enum State {
        case viewOnMap
        case register
        case forgotPassword
        case accountExist
        
        var fontSize: CGFloat {
            switch self {
            case .viewOnMap, .forgotPassword, .accountExist:
                return 12.0
            case .register:
                return 16.0
                
            }
        }
        
        var text: String {
            switch self {
            case .viewOnMap:
                return Strings.viewOnMap
            case .register:
                return Strings.register
            case .forgotPassword:
                return Strings.forgotPassword
            case .accountExist:
                return Strings.accountExist
            }
        }
        
        var textColor: UIColor {
            switch self {
            case .viewOnMap, .forgotPassword:
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
