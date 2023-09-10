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

    private let saloonNameLabel = UILabel(.systemFont(ofSize: 16))
    private let saloonClassLabel = UILabel(.systemFont(ofSize: 14), .textGray)
    
    private lazy var rightStackView = UIStackView(alignment: .trailing,
                                                  arrangedSubviews: [
                                                    saloonClassLabel
                                                  ],
                                                  axis: .vertical,
                                                  distribution: .equalSpacing,
                                                  spacing: 5)

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
        contentView.addSubviews([rightStackView, saloonNameLabel])
        
        rightStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).inset(16)
            make.bottom.equalTo(contentView).inset(20)
        }
        
        saloonNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(rightStackView)
            make.left.equalTo(contentView)
        }
    }
    
    private func setSelf() {
        contentView.backgroundColor = .mainGray
        selectionStyle = .none
        contentView.layer.cornerRadius = 0
        addLine()
    }
}
