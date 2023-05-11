//
//  DataCell.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import UIKit
import SnapKit

final class DataCell: BaseCollectionCell {
    
    // MARK: - Properties
    
    private let optionLabel = UILabel(.systemFont(ofSize: 12), .textGray)
    private let optionDescription = UILabel(.systemFont(ofSize: 16), .black, "Тест")

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setViews()
        setSelf()
    }
    
    func configure(model: SettingsMenuModel) {
        optionLabel.text = model.description
    }
}

extension DataCell {
    
    // MARK: - Instance methods
    
    private func setSelf() {
        layer.cornerRadius = 15
    }
    
    private func setViews() {
        addSubviews([optionLabel, optionDescription])
        snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        optionLabel.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.centerY.equalTo(self)
        }
        
        optionDescription.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(140)
        }
    }
}
