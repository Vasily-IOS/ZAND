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
    case sendCode // "Отправить код"
    case getCode // "Получить код"
    case approve // "Подтвердите запись"
    case save // "Cохранить"
    case refreshPass
    
    var text: String {
        switch self {
        case .apply:
            return AssetString.apply.rawValue
        case .enter:
            return AssetString.enter.rawValue
        case .register:
            return AssetString.register.rawValue
        case .book:
            return AssetString.book.rawValue
        case .contin:
            return AssetString.contin.rawValue
        case .callUs:
            return AssetString.callUs.rawValue
        case .sendCode:
            return AssetString.sendCode.rawValue
        case .getCode:
            return AssetString.getCode.rawValue
        case .approve:
            return AssetString.approveAppointment.rawValue
        case .save:
            return AssetString.save.rawValue
        case .refreshPass:
            return AssetString.refreshPassword.rawValue
        }
    }
}

final class BottomButton: UIButton {
    
    // MARK: - Properties
   
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
