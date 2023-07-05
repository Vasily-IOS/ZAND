//
//  AppointmentsCell.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import UIKit
import SnapKit

final class AppoitmentsCell: BaseTableCell {
    
    // MARK:  - Closures
    
    var mapHandler: ((CommonModel) -> ())?
    
    // MARK: - Properties
    
    var model: CommonModel?

    // MARK: - Private

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

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
        setSelf()
        setTarget()
    }
    
    func configure(model: CommonModel) {
        if let model = model as? AppointmentsModel {
            saloonNameLabel.text = model.saloon_name
            saloonAddressLabel.text = model.saloon_address
            dateLabel.text = model.bookingDate
            priceLabel.text = "\(StringsAsset.from) \(model.servicePrice) \(StringsAsset.rub)"
            timeLabel.text = model.bookingTime
            serviceTypeLabel.text = model.serviceName
        }
        self.model = model
    }

    // MARK: - Action
    
    @objc
    private func viewOnMapAction() {
        guard let model else { return }

        mapHandler?(model)
    }
}

extension AppoitmentsCell {
    
    // MARK: - Instance methods
    
    private func setViews() {
        contentView.addSubview(mainStackView)

        mainStackView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }

        baseView.addSubviews([saloonNameAddressStack, dateLabel,
                                 priceLabel, serviceTypeStackView,
                                 viewOnMapButton])

        saloonNameAddressStack.snp.makeConstraints { make in
            make.top.equalTo(baseView.snp.top).offset(32)
            make.left.equalTo(baseView.snp.left).offset(16)
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
            make.bottom.equalTo(baseView.snp.bottom).inset(33)
        }

        viewOnMapButton.snp.makeConstraints { make in
            make.right.equalTo(baseView.snp.right).inset(16)
            make.bottom.equalTo(baseView.snp.bottom).inset(10)
        }
    }
    
    private func setSelf() {
        layer.cornerRadius = 15
        clipsToBounds = true
    }
    
    private func setTarget() {
        viewOnMapButton.addTarget(self,
                                  action: #selector(viewOnMapAction),
                                  for: .touchUpInside)
    }
}
