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

    private let serviceButtonView = StartBookingButtonView(state: .service)

    private let staffButtonView = StartBookingButtonView(state: .sprecialist)

    private lazy var buttonStackView = UIStackView(
        alignment: .fill,
        arrangedSubviews: [
            serviceButtonView,
            staffButtonView
        ],
        axis: .horizontal,
        distribution: .fillEqually,
        spacing: 16)

    // MARK: - Lifecyle

    deinit {
        print("StartBookingView died")
    }

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
        setBookingViewActions()
    }

    private func setViews() {
        backgroundColor = .mainGray

        addSubviews([buttonStackView])
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(32)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(170)
        }
    }

    private func setBookingViewActions() {
        serviceButtonView.tapHandler = { [weak self] in
            self?.delegate?.openServices()
        }

        staffButtonView.tapHandler = { [weak self] in
            self?.delegate?.openStaff()
        }
    }
}
