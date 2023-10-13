//
//  AppointmentsCell.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import UIKit
import SnapKit

final class AppoitmentsCell: BaseTableCell {

    // MARK: - Properties

    var cancelButtonHandler: ((Int) -> Void)?

    var recordID = Int()

    private let saloonNameLabel: UILabel = {
        let saloonNameLabel = UILabel()
        saloonNameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        saloonNameLabel.numberOfLines = 0
        return saloonNameLabel
    }()

    private let saloonAddressLabel = UILabel(.systemFont(ofSize: 12))
    
    private lazy var saloonNameAddressStack = UIStackView(
        alignment: .leading,
        arrangedSubviews: [
            saloonNameLabel,
            saloonAddressLabel
        ],
        axis: .vertical,
        distribution: .fill,
        spacing: 8
    )
    
    private let dateLabel = UILabel(.systemFont(ofSize: 14))

    private let priceLabel = UILabel(.systemFont(ofSize: 14))

    private let timeLabel = UILabel(.systemFont(ofSize: 14))

    private let serviceTypeLabel = UILabel(.systemFont(ofSize: 12))
    
    private lazy var serviceTypeStackView = UIStackView(
        alignment: .leading,
        arrangedSubviews: [
            timeLabel,
            serviceTypeLabel
        ],
        axis: .vertical,
        distribution: .fill,
        spacing: 14
    )

    private let baseView: UIView = {
        let baseView = UIView()
        baseView.layer.cornerRadius = 15
        baseView.clipsToBounds = true
        baseView.backgroundColor = .white
        return baseView
    }()

    private let bottomView: UIView = {
        let bottomView = UIView()
        bottomView.backgroundColor = .mainGray
        return bottomView
    }()

    private lazy var mainStackView: UIStackView = {
        var mainStackView = UIStackView()
        mainStackView.alignment = .fill
        mainStackView.addArrangedSubviews([baseView, bottomView])
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.backgroundColor = .mainGray
        return mainStackView
    }()

    private let cancelRecordButton: UIButton = {
        let cancelRecordButton = UIButton()
        cancelRecordButton.layer.cornerRadius = 15.0
        cancelRecordButton.layer.borderWidth = 1
        cancelRecordButton.layer.borderColor = UIColor.lightGreen.cgColor
        cancelRecordButton.setTitle("Отменить запись", for: .normal)
        cancelRecordButton.setTitleColor(.lightGreen, for: .normal)
        return cancelRecordButton
    }()

    // MARK: - Instance methods

    @objc
    private func cancelButtonAction() {
        cancelButtonHandler?(recordID)
    }
    
    override func setup() {
        super.setup()

        setViews()
        setSelf()
        setTarget()
    }

    func configure(_ model: UIAppointmentModel) {
        recordID = model.id
        saloonNameLabel.text = model.company_name
        saloonAddressLabel.text = model.company_address
        serviceTypeLabel.text = model.services.title
        priceLabel.text = "\(model.services.cost) \(AssetString.rub)"
        dateLabel.text = model.seance_start_date
        timeLabel.text = model.seance_start_time
    }
}

extension AppoitmentsCell {
    
    // MARK: - Instance methods
    
    private func setViews() {
        contentView.addSubview(mainStackView)

        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }

        baseView.addSubviews(
            [saloonNameAddressStack, dateLabel, priceLabel, serviceTypeStackView, cancelRecordButton]
        )

        saloonNameAddressStack.snp.makeConstraints { make in
            make.top.equalTo(baseView.snp.top).offset(32)
            make.left.equalTo(baseView.snp.left).offset(16)
            make.right.equalToSuperview().inset(70)
        }

        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(saloonNameAddressStack.snp.bottom).offset(26)
            make.left.equalTo(baseView.snp.left).offset(16)
        }

        priceLabel.snp.makeConstraints { make in
            make.right.equalTo(baseView.snp.right).inset(16)
            make.centerY.equalTo(dateLabel)
        }

        serviceTypeStackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.left.equalTo(baseView.snp.left).offset(16)
        }

        cancelRecordButton.snp.makeConstraints { make in
            make.top.equalTo(serviceTypeStackView.snp.bottom).offset(10)
            make.height.equalTo(30)
            make.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.width.equalTo(170)
        }
    }
    
    private func setSelf() {
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    
    private func setTarget() {
        cancelRecordButton.addTarget(
            self,
            action: #selector(cancelButtonAction),
            for: .touchUpInside
        )
    }
}
