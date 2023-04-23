//
//  OptionCell.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit

final class OptionCell: BaseCollectionCell {
    
    override var isSelected: Bool {
        didSet {
            optionView.isSelected = isSelected
        }
    }
    
    // MARK: - Properties
    
    private let optionView = OptionView()
    private let descriptionLabel = UILabel(.systemFont(ofSize: 14), .black)
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setViews()
        setBackgroundColor()
    }
    
    // MARK: - Configure
    
    func configure(model: OptionsModel) {
        descriptionLabel.text = model.name
        optionView.configure(image: model.image)
    }
}

extension OptionCell {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([optionView, descriptionLabel])
        
        optionView.snp.makeConstraints { make in
            make.left.top.right.equalTo(self)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(optionView.snp.bottom).offset(8)
            make.centerX.equalTo(optionView)
        }
    }
    
    private func setBackgroundColor() {
        backgroundColor = .mainGray
    }
}
