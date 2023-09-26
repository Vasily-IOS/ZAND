//
//  TimeCell.swift
//  ZAND
//
//  Created by Василий on 26.09.2023.
//

import UIKit

final class TimeCell: BaseCollectionCell {

    // MARK: - Properties

    var timeIsSelected: Bool = false {
        didSet {
            timeLabel.textColor = timeIsSelected ? .black : .black.withAlphaComponent(0.5)
        }
    }

    private let timeLabel: UILabel = {
        let timeLabel = UILabel()
        timeLabel.text = "10:00"
        return timeLabel
    }()

    // MARK: - Instance methods

    func configure(model: String) {
        timeLabel.text = model
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
