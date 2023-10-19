//
//  UserNameView.swift
//  ZAND
//
//  Created by Василий on 27.04.2023.
//

import UIKit
import SnapKit

final class UserNameView: BaseUIView {
    
    // MARK: - Properties

    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 24, weight: .bold)
        nameLabel.numberOfLines = 0
        return nameLabel
    }()

    private let phoneLabel = UILabel(.systemFont(ofSize: 16), .black)

    private let emailLabel = UILabel(.systemFont(ofSize: 16), .black)
    
    private lazy var userNameStackView = UIStackView(
        arrangedSubviews:
            [phoneLabel,
             nameLabel,
             emailLabel],
        axis: .vertical,
        spacing: 10
    )

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
    }

    func configure(model: UserDataBaseModel) {
        nameLabel.text = model.givenName + " " + model.familyName
        phoneLabel.text = model.phone
        emailLabel.text = model.email
    }
}

extension UserNameView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        backgroundColor = .mainGray

        addSubview(userNameStackView)
        userNameStackView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
        }
    }
}
