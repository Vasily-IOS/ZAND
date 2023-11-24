//
//  TimeCell.swift
//  ZAND
//
//  Created by Василий on 26.09.2023.
//

import UIKit

final class TimeCell: BaseCollectionCell {

    // MARK: - Properties

    override var isSelected: Bool {
        didSet {
            timeLabel.textColor = isSelected ? .black : .black.withAlphaComponent(0.5)
        }
    }

    private let timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.textColor = .black.withAlphaComponent(0.5)
        return timeLabel
    }()

    // MARK: - Instance methods

    func configure(model: BookTimeModel) {
        timeLabel.text = model.time
    }

    override func setup() {
        super.setup()

        backgroundColor = .textGray.withAlphaComponent(0.3)
        layer.cornerRadius = 15.0

        addSubview(timeLabel)

        timeLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
