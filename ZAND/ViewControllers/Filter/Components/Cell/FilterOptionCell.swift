//
//  FilterOptionCell.swift
//  ZAND
//
//  Created by Василий on 24.04.2023.
//

import UIKit
import SnapKit

final class FilterOptionCell: BaseCollectionCell {
    
    // MARK: - Properties
    
    /// костыль, потом убрать
    var indexPath: IndexPath? {
        didSet {
            if indexPath?.row == 0 {
                circleImage.image = UIImage(named: "fillCircle_icon")
                backgroundColor = .superLightGreen
            }
        }
    }
    
    // MARK: - UI
    
    private let filterDescription = UILabel(.systemFont(ofSize: 16))
    private let circleImage = UIImageView(image: UIImage(named: "emptyCircle_icon"))

    // MARK: - Initializers

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setViews()
        setSelf()
    }
    
    // MARK: - Configure
    
    func configure(model: FilterModel, indexPath: IndexPath) {
        self.filterDescription.text = model.filterDescription
        self.indexPath = indexPath
    }
}

extension FilterOptionCell {
    
    private func setViews() {
        addSubviews([circleImage, filterDescription])
        
        circleImage.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(16)
        }
        
        filterDescription.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(72)
        }
    }
    
    private func setSelf() {
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGreen.cgColor
    }
}
