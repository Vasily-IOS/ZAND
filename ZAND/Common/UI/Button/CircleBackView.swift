//
//  CircleBackButton.swift
//  ZAND
//
//  Created by Василий on 11.05.2023.
//

import UIKit
import SnapKit

final class CircleBackView: UIView {
    
    // MARK: - Properties
    
    private let backImage: UIImageView = {
        let backImage = UIImageView(image: AssetImage.back_icon)
        backImage.contentMode = .scaleAspectFit
        backImage.clipsToBounds = true
        return backImage
    }()

    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
        setBackgroundColor()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CircleBackView {
    
    // MARK: - Instance methods
    
    private func setup() {
//        addSubview(backImage)
        layer.cornerRadius = 15

        snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
        
//        backImage.snp.makeConstraints { make in
//            make.centerY.centerX.equalTo(self)
//        }
    }
    
    private func setBackgroundColor() {
        backgroundColor = .white
    }
}
