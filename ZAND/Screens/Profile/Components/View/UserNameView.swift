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
        nameLabel.font = .systemFont(ofSize: 28, weight: .bold)
        nameLabel.numberOfLines = 0
        return nameLabel
    }()

    private let phoneLabel = UILabel(.systemFont(ofSize: 16), .black)

    private let emailLabel = UILabel(.systemFont(ofSize: 16), .black)

    private lazy var userNameStackView = UIStackView(
        arrangedSubviews: [nameLabel],
        axis: .vertical,
        spacing: 10
    )

    // MARK: - Instance methods
    
    override func setup() {
        setupViews()
    }

    func configure(model: UserDataBaseModel) {
        nameLabel.text = model.name + " " + model.surname
    }
}

extension UserNameView {
    
    // MARK: - Instance methods
    
    private func setupViews() {
        backgroundColor = .mainGray

        addSubview(userNameStackView)
        userNameStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }
    }
}
