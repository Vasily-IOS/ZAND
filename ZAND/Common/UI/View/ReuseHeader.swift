//
//  CustomHeader.swift
//  ZAND
//
//  Created by Василий on 24.04.2023.
//

import UIKit
import SnapKit

class ReuseHeader: UICollectionReusableView {
    
    enum HeaderText {
        case services
        case favourites
        
        var description: String {
            switch self {
            case .services:
                return Strings.services
            case .favourites:
                return Strings.favourites
            }
        }
    }
    
    // MARK: - Properties
    
    var state: HeaderText = .services {
        didSet {
            titleLabel.text = state.description
        }
    }

    private let titleLabel = UILabel(.systemFont(ofSize: 20, weight: .bold))
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReuseHeader {
    
    // MARK: - Instance method
    
    private func setViews() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.centerY.equalTo(self)
        }
    }
}
