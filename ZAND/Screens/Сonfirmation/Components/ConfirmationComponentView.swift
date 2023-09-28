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
        let nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        nameLabel.text = "tect 1"
        return nameLabel
    }()

    private let bottomLabel: UILabel = {
        let specializationLabel = UILabel()
        specializationLabel.font = .systemFont(ofSize: 15, weight: .medium)
        specializationLabel.numberOfLines = 0
        specializationLabel.text = "tect 2"
        return specializationLabel
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

    // MARK: - Initializers

    // MARK: - Instance methods

//    func configure(model: EmployeeCommon) {
//

//    }

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
