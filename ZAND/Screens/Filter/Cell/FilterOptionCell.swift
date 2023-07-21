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

    override var isSelected: Bool {
        didSet {
            fillCircleImage.isHidden = !isSelected
            backgroundColor = isSelected ? .superLightGreen : .white
        }
    }
    
    var indexPath: IndexPath?
    
    // MARK: - UI
    
    private let filterDescription = UILabel(.systemFont(ofSize: 16))
    private let circleImage = UIImageView(image: AssetImage.emptyCircle_icon)
    
    private let fillCircleImage: CheckMarkImageView = {
        let fillCircleImage = CheckMarkImageView(frame: .zero)
        fillCircleImage.isHidden = true
        return fillCircleImage
    }()

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
        setSelf()
    }
    
    // MARK: - Configure
    
    func configure(model: CommonFilterProtocol, indexPath: IndexPath) {
        if let model = model as? FilterModel {
            self.filterDescription.text = model.filterDescription
            self.indexPath = indexPath
        }
    }
}

extension FilterOptionCell {
    
    private func setViews() {
        addSubviews([circleImage, filterDescription])
        circleImage.addSubview(fillCircleImage)
        
        circleImage.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(16)
        }
        
        filterDescription.snp.makeConstraints { make in
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(72)
        }
        
        fillCircleImage.snp.makeConstraints { make in
            make.edges.equalTo(circleImage)
        }
    }
    
    private func setSelf() {
        layer.cornerRadius = 15
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGreen.cgColor
    }
}
