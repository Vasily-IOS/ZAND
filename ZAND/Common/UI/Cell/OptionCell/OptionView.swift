//
//  OptionView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit

final class OptionView: BaseUIView {

    // MARK: - Properties
    
    var isSelected: Bool = false {
        didSet {
            backgroundColor = isSelected ? .superLightGreen : .white
        }
    }
    
    private let optionImage = UIImageView()
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        
        setSelf()
        setViews()
    }

    func configure(image: UIImage) {
        self.optionImage.image = image
    }
}

extension OptionView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubview(optionImage)
        
        optionImage.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(self)
        }
    }
    
    private func setSelf() {
        self.snp.makeConstraints { make in
            make.width.height.equalTo(75)
        }
        layer.cornerRadius = 15
        layer.borderWidth = 2
        layer.borderColor = UIColor.lightGreen.cgColor
    }
}
