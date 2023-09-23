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

    func configure(model: Employee) {
        nameLabel.text = model.name
        specializationLabel.text = model.specialization

        if let url = URL(string: model.avatar) {
            avatarImage.kf.setImage(with: url)
        }
    }
//
//    func configure(model: Staff) {
//        nameLabel.text = model.name
//
//        if let url = URL(string: model.image_url) {
//            avatarImage.kf.setImage(with: url)
//        }
//    }

    override func setup() {
        super.setup()

        contentView.backgroundColor = .textGray.withAlphaComponent(0.3)
        contentView.layer.cornerRadius = 15.0
        layer.cornerRadius = 15.0

        contentView.addSubviews([avatarImage, stackView])

        avatarImage.snp.makeConstraints { make in
            make.width.height.equalTo(88)
            make.left.equalTo(contentView).offset(16)
            make.top.equalTo(contentView.snp.top).offset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(16)
        }

        stackView.snp.makeConstraints { make in
            make.left.equalTo(avatarImage.snp.right).offset(16)
            make.centerY.equalTo(avatarImage)
            make.right.equalTo(contentView.snp.right).inset(16)
        }
    }
}
