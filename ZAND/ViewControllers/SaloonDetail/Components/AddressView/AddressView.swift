//
//  AddressView.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit
import SnapKit

final class AddressView: BaseUIView {
    
    // MARK: - Model
    
    private let model: SaloonMockModel
    
    // MARK: - UI
    
    private let addressLabel = UILabel(.systemFont(ofSize: 16), .black, StringsAsset.address)
    private let viewOnMapButton = TransparentButton(state: .viewOnMap)
    private let weedDaysLabel = UILabel(.systemFont(ofSize: 12), .black, StringsAsset.weekDays)
    private let weekDaysDescriptionLabel = UILabel(.systemFont(ofSize: 12))
    private let weekendDaysLabel = UILabel(.systemFont(ofSize: 12), .black, StringsAsset.weekendDays)
    private let weekendDaysDescriptionLabel = UILabel(.systemFont(ofSize: 12))
    private let minPriceLabel = UILabel(.systemFont(ofSize: 12))
    
    private lazy var weekDaysStackView = UIStackView(alignment: .trailing,
                                                     arrangedSubviews: [
                                                        weedDaysLabel,
                                                        weekDaysDescriptionLabel
                                                     ],
                                                     axis: .vertical,
                                                     distribution: .equalSpacing,
                                                     spacing: 2)
    private lazy var weekendDaysStackView = UIStackView(alignment: .trailing,
                                                     arrangedSubviews: [
                                                        weekendDaysLabel,
                                                        weekendDaysDescriptionLabel
                                                     ],
                                                        axis: .vertical,
                                                        distribution: .equalSpacing,
                                                     spacing: 2)
    
    private let addressDescriptionLabel: UILabel = {
        let addressDescriptionLabel = UILabel()
        addressDescriptionLabel.font = .systemFont(ofSize: 12)
        addressDescriptionLabel.numberOfLines = 0
        return addressDescriptionLabel
    }()
    
    // MARK: - Initializers
    
    init(model: SaloonMockModel) {
        self.model = model
        super.init(frame: .zero)
        configure(model: model)
    }
        
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setSelf()
        setViews()
        addTarget()
    }
    
    private func configure(model: SaloonMockModel) {
        addressDescriptionLabel.text = model.adress
        weekDaysDescriptionLabel.text = model.weekdays
        weekendDaysDescriptionLabel.text = model.weekend
        minPriceLabel.text = "\(StringsAsset.from) \(model.min_price) \(StringsAsset.rub)"
    }
    
    // MARK: - Action
    
    @objc
    private func viewOnMapAction() {
        AppRouter.shared.push(.selectableMap(model.coordinates))
    }
}

extension AddressView {
    
    // MARK: - Instance methods
    
    private func setSelf() {
        layer.cornerRadius = 15.0
    }
    
    private func setViews() {
        addSubviews([addressLabel, addressDescriptionLabel, viewOnMapButton,
                    weekDaysStackView, weekendDaysStackView, minPriceLabel])
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(12)
            make.left.equalTo(self).offset(16)
        }
        
        addressDescriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.top.equalTo(addressLabel.snp.bottom).offset(8)
            make.width.equalTo(130)
        }
        
        viewOnMapButton.snp.makeConstraints { make in
            make.top.equalTo(addressDescriptionLabel.snp.bottom).offset(37)
            make.bottom.equalTo(self).inset(8)
            make.left.equalTo(self).offset(16)
        }
        
        weekDaysStackView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(10)
            make.right.equalTo(self).inset(25)
        }
        
        weekendDaysStackView.snp.makeConstraints { make in
            make.top.equalTo(weekDaysStackView.snp.bottom).offset(8)
            make.right.equalTo(self).inset(25)
        }
        
        minPriceLabel.snp.makeConstraints { make in
            make.centerY.equalTo(viewOnMapButton)
            make.right.equalTo(self).inset(25)
        }
    }
    
    private func addTarget() {
        viewOnMapButton.addTarget(self, action: #selector(viewOnMapAction), for: .touchUpInside)
    }
}
