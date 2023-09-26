//
//  DayCell.swift
//  ZAND
//
//  Created by Василий on 26.09.2023.
//

import UIKit

final class DayCell: BaseCollectionCell {

    // MARK: - Properties

    var dayIsSelected: Bool = false {
        didSet {
            if dayIsSelected {
                backgroundColor = .mainGreen
                [dayNumericLabel, daySringLabel].forEach { $0.textColor = .white }
            } else {
                backgroundColor = .textGray.withAlphaComponent(0.3)
                [dayNumericLabel, daySringLabel].forEach { $0.textColor = .black }
            }
        }
    }

    private let dayNumericLabel = UILabel()

    private let daySringLabel = UILabel()

    private lazy var stackView = UIStackView(
        alignment: .center,
        arrangedSubviews: [
            dayNumericLabel,
            daySringLabel
        ],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 5
    )

    // MARK: - Instance methods

    func configure(model: WorkingRangeItem) {
        dayNumericLabel.text = model.dayNumeric
        daySringLabel.text = model.dayString
    }

    override func setup() {
        super.setup()
        
        backgroundColor = .textGray.withAlphaComponent(0.3)
        layer.cornerRadius = 15.0

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
