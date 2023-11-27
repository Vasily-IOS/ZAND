//
//  BadInternetConnectionView.swift
//  ZAND
//
//  Created by Василий on 26.11.2023.
//

import UIKit
import SnapKit

final class BadInternetConnectionView: BaseUIView {

    // MARK: - Properties

    private let topLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.text = AssetString.badConnection1.rawValue
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let bottomLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.text = AssetString.badConnection2.rawValue
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private lazy var stackView = UIStackView(
        alignment: .leading,
        arrangedSubviews: [
            topLabel,
            bottomLabel
        ],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 10
    )

    // MARK: - Instance methods

    override func setup() {
        setupSubviews()
    }

    private func setupSubviews() {
        backgroundColor = .gray
        layer.cornerRadius = 15.0

        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
