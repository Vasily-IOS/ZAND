//
//  ServiceCell.swift
//  ZAND
//
//  Created by Василий on 23.09.2023.
//

import UIKit
import SnapKit

final class ServiceCell: BaseTableCell {

    // MARK: - Properties

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 20)
        titleLabel.numberOfLines = 0
        return titleLabel
    }()

    private let priceLabel: UILabel = {
        let priceLabel = UILabel()
        priceLabel.textColor = .mainGreen
        priceLabel.font = .systemFont(ofSize: 20)
        return priceLabel
    }()
    
    private let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        return descriptionLabel
    }()

    // MARK: - Instance methods

    func configure(model: Service?) {
        guard let model = model else { return }

        titleLabel.text = model.title.html2String
        priceLabel.text = model.price_min == 0 ?
        (String(model.price_max) + " " + "руб.").html2String : (String(model.price_min) + " " + "руб.").html2String
        descriptionLabel.text = model.comment
    }

    override func setup() {
        super.setup()

        contentView.layer.cornerRadius = 0.0
        addLine()

        contentView.addSubviews([titleLabel, priceLabel, descriptionLabel])

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(8)
            make.right.equalTo(contentView.snp.right).inset(32)
            make.left.equalTo(contentView).offset(16)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.left.equalTo(titleLabel)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(priceLabel.snp.bottom).offset(8)
            make.left.equalTo(priceLabel)
            make.right.equalTo(contentView.snp.right).inset(32)
            make.bottom.equalTo(contentView.snp.bottom).inset(16)
        }
    }
}
