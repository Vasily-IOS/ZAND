//
//  CircleBackButton.swift
//  ZAND
//
//  Created by Василий on 11.05.2023.
//

import UIKit
import SnapKit

final class CircleBackButton: UIButton {

    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CircleBackButton {
    
    // MARK: - Instance methods
    
    private func setup() {
        backgroundColor = .white
        setImage(UIImage(named: "back_icon"), for: .normal)
        layer.cornerRadius = 15

        snp.makeConstraints { make in
            make.width.height.equalTo(30)
        }
    }
}
