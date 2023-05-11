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
    
    private let saloonNameLabel = UILabel(.systemFont(ofSize: 20, weight: .bold))
    private let saloonAddressLabel = UILabel(.systemFont(ofSize: 12))
    
    private lazy var saloonNameAddressStack = UIStackView(alignment: .leading,
                                                          arrangedSubviews: [
                                                            saloonNameLabel,
                                                            saloonAddressLabel
                                                          ],
                                                          axis: .vertical,
                                                          distribution: .fill,
                                                          spacing: 8)
    
    private let dateLabel = UILabel(.systemFont(ofSize: 14))
    private let priceLabel = UILabel(.systemFont(ofSize: 14))
    private let timeLabel = UILabel(.systemFont(ofSize: 14))
    private let serviceTypeLabel = UILabel(.systemFont(ofSize: 12))
    
    private lazy var serviceTypeStackView = UIStackView(alignment: .leading,
                                                        arrangedSubviews: [
                                                            timeLabel,
                                                            serviceTypeLabel
                                                        ],
                                                        axis: .vertical,
                                                        distribution: .fill,
                                                        spacing: 14)
    private let viewOnMapButton = TransparentButton(state: .viewOnMap)
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setViews()
        setSelf()
    }
    
    func configure(model: AppointmentsModel) {
        saloonNameLabel.text = model.saloon_name
        saloonAddressLabel.text = model.saloon_address
        dateLabel.text = model.bookingDate
        priceLabel.text = "от \(model.servicePrice) руб."
        timeLabel.text = model.bookingTime
        serviceTypeLabel.text = model.serviceName
    }
}

extension AppoitmentsCell {
    
    // MARK: - Instance methods
    
    private func setViews() {
        contentView.addSubviews([saloonNameAddressStack, dateLabel,
                                 priceLabel, serviceTypeStackView,
                                 viewOnMapButton])
        
        saloonNameAddressStack.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(32)
            make.left.equalTo(contentView.snp.left).offset(16)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(saloonNameAddressStack.snp.bottom).offset(26)
            make.left.equalTo(contentView.snp.left).offset(16)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.right).inset(16)
            make.centerY.equalTo(dateLabel)
        }
        
        serviceTypeStackView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(8)
            make.left.equalTo(contentView.snp.left).offset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(33)
        }
        
        viewOnMapButton.snp.makeConstraints { make in
            make.right.equalTo(contentView.snp.right).inset(16)
            make.bottom.equalTo(contentView.snp.bottom).inset(10)
        }
    }
    
    private func setSelf() {
        layer.cornerRadius = 15
        clipsToBounds = true
    }
}
