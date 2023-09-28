//
//  ConfirmationComponentView.swift
//  ZAND
//
//  Created by Василий on 28.09.2023.
//

import UIKit

final class ConfirmationComponentView: BaseUIView {

    // MARK: - Properties

    private let topLabel: UILabel = {
        let topLabel = UILabel()
        topLabel.font = .systemFont(ofSize: 18, weight: .bold)
        topLabel.numberOfLines = 0
        return topLabel
    }()

    private let bottomLabel: UILabel = {
        let bottomLabel = UILabel()
        bottomLabel.font = .systemFont(ofSize: 15, weight: .medium)
        bottomLabel.numberOfLines = 0
        return bottomLabel
    }()

    private lazy var stackView = UIStackView(
        alignment: .leading,
        arrangedSubviews: [
            topLabel,
            bottomLabel
        ],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 20
    )

    // MARK: - Instance methods

    func configure(topText: String, bottomText: String) {
        topLabel.text = topText
        bottomLabel.text = bottomText
    }

    override func setup() {
        super.setup()

        backgroundColor = .textGray.withAlphaComponent(0.3)
        layer.cornerRadius = 15.0
        layer.cornerRadius = 15.0

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(16)
        }
    }
}
