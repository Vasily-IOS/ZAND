//
//  BottomButton.swift
//  ZAND
//
//  Created by Василий on 21.04.2023.
//

import UIKit

enum ButtonText {
    case apply //"Применить"
    case enter //"Войти"
    case register //"Зарегистрироваться"
    case book //"Записаться"
    case contin //"Далее"
    case callUs //"Свяжитесь с нами"
    
    var text: String {
        switch self {
        case .apply:
            return Strings.apply
        case .enter:
            return Strings.enter
        case .register:
            return Strings.register
        case .book:
            return Strings.book
        case .contin:
            return Strings.contin
        case .callUs:
            return Strings.callUs
        }
    }
}

final class BottomButton: UIButton {
    
    // MARK: - Properties
    
    /// костыль, будет MVVM!!
    var stateText: ButtonText? = nil {
        didSet {
            if let stateText = stateText {
                setTitleForSelf(text: stateText.text)
            }
        }
    }
    
    // MARK: - Initializers

    init(buttonText: ButtonText) {
        super.init(frame: .zero)
        setup()
        setTitleForSelf(text: buttonText.text)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BottomButton {
    
    // MARK: - Instance methods
    
    private func setup() {
        layer.cornerRadius = 15.0
        backgroundColor = .mainGreen
        setTitleColor(.white, for: .normal)
    }
    
    private func setTitleForSelf(text: String) {
        setTitle(text, for: .normal)
    }
}
