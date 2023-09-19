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

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
        setSelf()
    }

    // MARK: - Configure

    func configure(model: Saloon) {
        saloonNameLabel.text = model.title
        saloonClassLabel.text = String(model.short_descr)
    }
}

extension SearchCell {
    
    // MARK: - Instance methods
    
    private func setViews()  {
        contentView.addSubviews([saloonNameLabel, saloonClassLabel])

        saloonNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
        }

        saloonClassLabel.snp.makeConstraints { make in
            make.top.equalTo(saloonNameLabel.snp.bottom).offset(5)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView).inset(16)
        }
    }
    
    private func setSelf() {
        contentView.backgroundColor = .mainGray
        selectionStyle = .none
        addLine()
    }
}
