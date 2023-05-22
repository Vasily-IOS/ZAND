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
    
    private let checkMarkImage = UIImageView(image: UIImage(named: "checkMark_icon"))

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
        image = UIImage(named: "fillCircle_icon")
        addSubview(checkMarkImage)
        
        checkMarkImage.snp.makeConstraints { make in
            make.centerY.centerX.equalTo(self)
        }
    }
}
