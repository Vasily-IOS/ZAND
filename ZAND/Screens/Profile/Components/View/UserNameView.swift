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
        .systemFont(ofSize: 20, weight: .bold), .black
    )

    private let phoneLabel = UILabel(.systemFont(ofSize: 16), .black)
    
    private lazy var userNameStackView = UIStackView(
        arrangedSubviews:
            [nameLabel,
             phoneLabel],
        axis: .vertical,
        spacing: 10
    )

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setViews()
    }

    func configure(model: UserModel) {
        print(model.name)
        nameLabel.text = model.name
        phoneLabel.text = model.phone
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
