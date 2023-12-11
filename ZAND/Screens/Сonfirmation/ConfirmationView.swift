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

    let staffComponentView = StaffComponentView()

    let dateComponentView = ConfirmationComponentView()

    let serviceComponentView = ConfirmationComponentView()

    let nameComponentView = ConfirmationComponentView()

    let phoneComponentView = ConfirmationComponentView()

    lazy var entryConfirmedView: EntryConfirmedView = {
        let entryConfirmedView = EntryConfirmedView()
        entryConfirmedView.frame = bounds
        return entryConfirmedView
    }()

    private let confirmationButton = BottomButton(buttonText: .approve)

    private lazy var topStackView = UIStackView(
        alignment: .fill,
        arrangedSubviews: [
            staffComponentView,
            dateComponentView,
            serviceComponentView
        ],
        axis: .vertical,
        distribution: .fill,
        spacing: 20
    )

    private lazy var bottomStackView = UIStackView(
        alignment: .leading,
        arrangedSubviews: [
            nameComponentView,
            phoneComponentView
        ],
        axis: .horizontal,
        distribution: .fillProportionally,
        spacing: 20
    )

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .white
        return scrollView
    }()

    // MARK: - Lifecycle

    deinit {
        print("ConfirmationView died")
    }

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

    func turnOffConfirmationButton() {
        confirmationButton.isUserInteractionEnabled = false
    }

    func configure(viewModel: ConfirmationViewModel) {
        staffComponentView.configure(model: viewModel.employeeCommon)
        nameComponentView.configure(
            topText: AssetString.name.rawValue,
            bottomText: viewModel.fullName
        )
        phoneComponentView.configure(
            topText: AssetString.phone.rawValue,
            bottomText: viewModel.phone
        )
        serviceComponentView.configure(
            topText: viewModel.bookService?.title ?? "",
            bottomText: "\(viewModel.bookService?.price_max ?? 0) руб."
        )

        dateComponentView.configure(
            topText: viewModel.startSeanceDate ?? "",
            bottomText: viewModel.startSeanceTime ?? ""
        )
    }

    private func setupSubviews() {
        addSubviews([scrollView, confirmationButton])
        scrollView.addSubviews([topStackView, bottomStackView])

        confirmationButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(20)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(confirmationButton.snp.top).inset(-10)
        }

        topStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalTo(scrollView.snp.right).inset(20)
            make.centerX.equalTo(scrollView)
        }

        bottomStackView.snp.makeConstraints { make in
            make.top.equalTo(topStackView.snp.bottom).offset(20)
            make.left.right.equalTo(topStackView)
            make.bottom.equalTo(scrollView)
        }
    }

    private func setTargets() {
        confirmationButton.addTarget(
            self,
            action: #selector(confirmAction),
            for: .touchUpInside
        )
    }
}
