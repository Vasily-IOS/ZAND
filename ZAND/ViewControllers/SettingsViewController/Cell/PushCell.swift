//
//  PushCell.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import UIKit
import SnapKit

final class PushCell: BaseCollectionCell {
    
    // MARK: - Properties
    
    private let pushLabel = UILabel(.systemFont(ofSize: 12), .black, StringsAsset.pushesAboutOrder)
    private let optionDescriptionLabel = UILabel(.systemFont(ofSize: 12), .textGray, StringsAsset.writeAboutBook)
    private lazy var stackView = UIStackView(alignment: .leading,
                                             arrangedSubviews: [
                                                pushLabel,
                                                optionDescriptionLabel
                                             ],
                                             axis: .vertical,
                                             distribution: .equalSpacing,
                                             spacing: 2)
    
    private lazy var switchControl: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = false
        switchControl.onTintColor = .mainGreen
        return switchControl
    }()

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setViews()
        setSelf()
    }
}

extension PushCell {
    
    // MARK: - Instance methods
    
    private func setSelf() {
        layer.cornerRadius = 15
    }
    
    private func setViews() {
        addSubviews([stackView, switchControl])
        
        snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        stackView.snp.makeConstraints { make in
            make.left.equalTo(self).offset(16)
            make.centerY.equalTo(self)
        }
        
        switchControl.snp.makeConstraints { make in
            make.right.equalTo(self).inset(16)
            make.centerY.equalTo(self)
        }
    }
}
