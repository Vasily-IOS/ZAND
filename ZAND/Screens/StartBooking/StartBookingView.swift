//
//  StartBookingView.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import UIKit
import SnapKit

protocol StartBookingDelegate: AnyObject {
    func openServices()
    func openStaff()
}

final class StartBookingView: BaseUIView {

    // MARK: - Properties

    weak var delegate: StartBookingDelegate?

    private let titleLabel = UILabel(
        .systemFont(ofSize: 20, weight: .bold),
        .black, AssetString.howStart
    )

    private let serviceButton = StartBookingButton(title: AssetString.selectService)

    private let staffButton = StartBookingButton(title: AssetString.selectStaff)

    private lazy var buttonStackView = UIStackView(
        alignment: .fill,
        arrangedSubviews: [
            serviceButton,
            staffButton
        ],
        axis: .horizontal,
        distribution: .fillEqually,
        spacing: 16)

    // MARK: - Instance methods

    @objc
    private func showServicesAction() {
        delegate?.openServices()
    }

    @objc
    private func showStaffAction() {
        delegate?.openStaff()
    }

    override func setup() {
        super.setup()

        setViews()
        setTargets()
    }

    private func setViews() {
        backgroundColor = .mainGray

        addSubviews([titleLabel, buttonStackView])

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalToSuperview().offset(16)
        }

        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(170)
        }
    }

    private func setTargets() {
        serviceButton.addTarget(
            self,
            action: #selector(showServicesAction),
            for: .touchUpInside)
        staffButton.addTarget(
            self,
            action: #selector(showStaffAction),
            for: .touchUpInside)
    }
}
