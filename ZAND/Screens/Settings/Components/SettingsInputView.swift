//
//  SettingsInputView.swift
//  ZAND
//
//  Created by Василий on 29.12.2023.
//

import UIKit
import SnapKit

final class SettingsInputView: UIView {

    // MARK: - Nested types

    enum State {
        case name
        case surname
        case fathersName
        case birthday
        case phone
        case email

        var textValue: String {
            switch self {
            case .name:
                return AssetString.name.rawValue
            case .surname:
                return AssetString.surname.rawValue
            case .fathersName:
                return AssetString.fathersName.rawValue
            case .birthday:
                return AssetString.birthday.rawValue
            case .phone:
                return AssetString.phone.rawValue
            case .email:
                return AssetString.email.rawValue
            }
        }
    }

    // MARK: - Properties

    private let descriptionLabel = UILabel(.systemFont(ofSize: 12.0), .textGray)

    private let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Пока нет данных"
        textField.backgroundColor = .white
        return textField
    }()

    // MARK: - Initializers

    init(state: State) {
        super.init(frame: .zero)

        setup(state: state)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Instance methods

    func setText(text: String) {
        textField.text = text
    }

    func changeBackground(color: UIColor) {
        backgroundColor = color
        textField.backgroundColor = color
    }

    private func setup(state: State) {
        backgroundColor = .white
        layer.cornerRadius = 15.0
        descriptionLabel.text = state.textValue

        addSubviews([descriptionLabel, textField])

        snp.makeConstraints { make in
            make.height.equalTo(48)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
        }

        textField.snp.makeConstraints { make in
            make.centerY.equalTo(descriptionLabel)
            make.left.equalToSuperview().offset(120)
            make.right.equalToSuperview().inset(10)
        }
    }
}
