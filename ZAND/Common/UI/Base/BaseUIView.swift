//
//  BaseUIView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

class BaseUIView: UIView {
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Instance methods
    
    func setup() {
        backgroundColor = .white
    }
}
