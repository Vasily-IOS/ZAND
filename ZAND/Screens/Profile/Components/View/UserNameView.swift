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

    private let nameLabel = UILabel(
        .systemFont(ofSize: 24, weight: .bold), .black
    )

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

    func configure(model: UserModelDB) {
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
            make.edges.equalTo(self)
        }
    }
}
