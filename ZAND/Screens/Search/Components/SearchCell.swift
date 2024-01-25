//
//  SearchCell.swift
//  ZAND
//
//  Created by Василий on 06.06.2023.
//

import UIKit
import SnapKit

final class SearchCell: BaseTableCell {
    
    // MARK: - Properties

    private let saloonNameLabel: UILabel = {
        let saloonNameLabel = UILabel(.systemFont(ofSize: 16))
        saloonNameLabel.numberOfLines = 0
        return saloonNameLabel
    }()

    private let saloonClassLabel = UILabel(.systemFont(ofSize: 14), .textGray)

    private let distanceLabel = UILabel(.systemFont(ofSize: 14), .textGray)

    private lazy var leftAlignStackView = UIStackView(
        alignment: .leading,
        arrangedSubviews: [
            saloonNameLabel,
            saloonClassLabel
        ],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 5)

    private lazy var rightAlignStackView = UIStackView(
        alignment: .trailing,
        arrangedSubviews: [
            distanceLabel
        ],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 0)

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
        setSelf()
    }

    // MARK: - Configure

    func configure(model: Saloon) {
        saloonNameLabel.text = model.saloonCodable.title
        saloonClassLabel.text = String(model.saloonCodable.shortDescription)
        distanceLabel.text = model.distance == nil ? "" : model.distanceString ?? ""
    }
}

extension SearchCell {
    
    // MARK: - Instance methods
    
    private func setViews()  {
        contentView.addSubviews([leftAlignStackView, rightAlignStackView])

        leftAlignStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.left.right.equalTo(contentView)
        }

        rightAlignStackView.snp.makeConstraints { make in
            make.top.equalTo(leftAlignStackView.snp.bottom).offset(5)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(16)
        }
    }
    
    private func setSelf() {
        backgroundColor = .mainGray
        contentView.backgroundColor = .mainGray
        selectionStyle = .none
        addLine()
    }
}
