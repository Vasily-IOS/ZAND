//
//  CategoryCell.swift
//  ZAND
//
//  Created by Василий on 23.09.2023.
//

import UIKit
import SnapKit

final class CategoryCell: BaseTableCell {

    // MARK: - Properties

    private let categoryLabel: UILabel = {
        let categoryLabel = UILabel()
        categoryLabel.font = .systemFont(ofSize: 18, weight: .medium)
        categoryLabel.numberOfLines = 0
        return categoryLabel
    }()

    private let arrowImage: UIImageView = {
        let arrowImage = UIImageView(image: AssetImage.arrow_icon.image)
        arrowImage.isUserInteractionEnabled = false
        return arrowImage
    }()

    // MARK: - Instance methods

    func configure(model: CategoriesModel) {
        categoryLabel.text = model.category.title
    }

    override func setup() {
        contentView.backgroundColor = .mainGray

        addLine()
        setupSubviews()
    }

    private func setupSubviews() {
        contentView.addSubviews([categoryLabel, arrowImage])

        categoryLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.left.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(16)
            make.right.equalTo(contentView.snp.right).inset(56)
        }

        arrowImage.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.right).inset(16)
            make.centerY.equalTo(categoryLabel)
            make.width.equalTo(15)
            make.height.equalTo(15)
        }
    }
}
