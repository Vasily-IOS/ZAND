//
//  StaffCell.swift
//  ZAND
//
//  Created by Василий on 19.09.2023.
//

import UIKit
import SnapKit
import Kingfisher

final class StaffCell: BaseTableCell {

    // MARK: - Properties

    private let avatarImage: UIImageView = {
        let avatarImage = UIImageView()
        avatarImage.layer.cornerRadius = 44.0
        avatarImage.clipsToBounds = true
        return avatarImage
    }()

    private let nameLabel: UILabel = {
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        return nameLabel
    }()

    private let specializationLabel: UILabel = {
        let specializationLabel = UILabel()
        specializationLabel.font = .systemFont(ofSize: 15, weight: .medium)
        specializationLabel.numberOfLines = 0
        return specializationLabel
    }()

    // MARK: - Instance methods

    func configure(model: Employee) {
        nameLabel.text = model.name
        specializationLabel.text = model.specialization

        if let url = URL(string: model.avatar) {
            avatarImage.kf.setImage(with: url)
        }
    }

    override func setup() {
        super.setup()

        contentView.backgroundColor = .textGray
        contentView.layer.cornerRadius = 15.0
        layer.cornerRadius = 15.0

        contentView.addSubviews([avatarImage, nameLabel, specializationLabel])

        avatarImage.snp.makeConstraints { make in
            make.width.height.equalTo(88)
            make.left.equalTo(contentView).offset(16)
            make.top.equalTo(contentView.snp.top).offset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(16)
        }

        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImage)
            make.left.equalTo(avatarImage.snp.right).offset(16)
        }

        specializationLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(16)
            make.left.equalTo(nameLabel)
            make.right.equalTo(contentView.snp.right).inset(16)
        }
    }
}
