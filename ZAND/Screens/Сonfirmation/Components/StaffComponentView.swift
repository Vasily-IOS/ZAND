//
//  StaffComponentView.swift
//  ZAND
//
//  Created by Василий on 28.09.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class StaffComponentView: BaseUIView {

    // MARK: - Properties

    private let avatarImage: UIImageView = {
        let avatarImage = UIImageView()
        avatarImage.layer.cornerRadius = 44.0
        avatarImage.clipsToBounds = true
        avatarImage.image = AssetImage.profile_icon
        return avatarImage
    }()

    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.text = "tect 1"
        return nameLabel
    }()

    private let specializationLabel: UILabel = {
        let specializationLabel = UILabel()
        specializationLabel.font = .systemFont(ofSize: 15, weight: .medium)
        specializationLabel.numberOfLines = 0
        specializationLabel.text = "test 2"
        return specializationLabel
    }()

    private lazy var stackView = UIStackView(
        alignment: .leading,
        arrangedSubviews: [
            nameLabel,
            specializationLabel
        ],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 20)

    // MARK: - Instance methods

//    func configure(model: EmployeeCommon) {
//        nameLabel.text = model.name
//        specializationLabel.text = model.specialization
//
//        if let url = URL(string: model.avatar) {
//            avatarImage.kf.setImage(with: url)
//        }
//    }

    override func setup() {
        super.setup()

        backgroundColor = .textGray.withAlphaComponent(0.3)
        layer.cornerRadius = 15.0
        layer.cornerRadius = 15.0

        addSubviews([avatarImage, stackView])

        avatarImage.snp.makeConstraints { make in
            make.width.height.equalTo(88)
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().inset(16)
        }

        stackView.snp.makeConstraints { make in
            make.left.equalTo(avatarImage.snp.right).offset(16)
            make.centerY.equalTo(avatarImage)
            make.right.equalToSuperview().inset(16)
        }
    }
}

