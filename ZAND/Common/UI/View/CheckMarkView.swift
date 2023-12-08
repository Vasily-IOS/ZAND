//
//  CheckMarkView.swift
//  ZAND
//
//  Created by Василий on 22.05.2023.
//

import UIKit
import SnapKit

final class CheckMarkImageView: UIImageView {
    
    // MARK: - Properties
    
    private let checkMarkImage = UIImageView(image: AssetImage.checkMark_icon.image)

    // MARK: - Initializers
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CheckMarkImageView {
    
    // MARK: - Instance methods
    
    private func setup() {
        image = AssetImage.fillCircle_icon.image
        addSubview(checkMarkImage)
        
        checkMarkImage.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(self)
        }
    }
}
