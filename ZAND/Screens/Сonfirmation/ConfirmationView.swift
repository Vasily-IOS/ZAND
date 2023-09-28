//
//  ConfirmationView.swift
//  ZAND
//
//  Created by Василий on 28.09.2023.
//

import UIKit
import SnapKit

protocol ConfirmationViewDelegate: AnyObject {
    func confirm()
}

final class ConfirmationView: BaseUIView {

    // MARK: - Properties

    weak var delegate: ConfirmationViewDelegate?

    private let staffComponentView = StaffComponentView()

    private let dateComponentView = ConfirmationComponentView()

    private let serviceComponentView = ConfirmationComponentView()

    private let nameComponentView = ConfirmationComponentView()

    private let phoneComponentView = ConfirmationComponentView()

    private let bottomButton = BottomButton(buttonText: .approve)

    private lazy var topStackView = UIStackView(
        alignment: .fill,
        arrangedSubviews: [
            staffComponentView,
            dateComponentView,
            serviceComponentView
        ],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 20
    )

    private lazy var bottomStackView = UIStackView(
        alignment: .fill,
        arrangedSubviews: [
            nameComponentView,
            phoneComponentView
        ],
        axis: .horizontal,
        distribution: .fillProportionally,
        spacing: 20
    )

    // MARK: - Instance methods

    @objc
    private func confirmAction() {
        delegate?.confirm()
    }

    override func setup() {
        super.setup()

        setupSubviews()
        setTargets()
    }

    private func setupSubviews() {
        addSubviews([topStackView, bottomStackView, bottomButton])

        topStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }

        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().inset(20)
        }

        bottomButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
        }
    }

    private func setTargets() {
        bottomButton.addTarget(
            self,
            action: #selector(confirmAction),
            for: .touchUpInside
        )
    }
}
