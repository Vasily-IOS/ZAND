//
//  FilterCell.swift
//  ZAND
//
//  Created by Василий on 24.04.2023.
//

import UIKit
import SnapKit

final class FilterCell: BaseCollectionCell, CellTappedIndicator {
    
    // MARK: - Properties

    var isTapped: Bool = false {
        didSet {
            fillCircleImage.isHidden = !isTapped
            backgroundColor = isTapped ? .superLightGreen : .white
        }
    }
    
    var indexPath: IndexPath?

    private let filterDescription = UILabel(.systemFont(ofSize: 16))

    private let circleImage = UIImageView(image: AssetImage.emptyCircle_icon.image)
    
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

    func toggle() {
        isTapped = !isTapped
    }
    
    func configure(model: CommonFilterProtocol, indexPath: IndexPath) {
        if let model = model as? FilterModel {
            self.filterDescription.text = model.title
            self.indexPath = indexPath
        }
    }
}

extension FilterCell {
    
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
