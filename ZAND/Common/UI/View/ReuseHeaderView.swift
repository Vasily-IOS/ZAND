//
//  CustomHeader.swift
//  ZAND
//
//  Created by Василий on 24.04.2023.
//

import UIKit
import SnapKit

final class ReuseHeaderView: UICollectionReusableView {
    
    // MARK: - Nested types
    enum HeaderText {
        case services
        case favourites
        case data
        case pushes
        
        var description: String {
            switch self {
            case .services:
                return AssetString.services
            case .favourites:
                return AssetString.favourites
            case .data:
                return AssetString.myData
            case .pushes:
                return AssetString.pushSms
            }
        }
    }
    
    // MARK: - Properties
    
    var state: HeaderText = .services {
        didSet {
            titleLabel.text = state.description
        }
    }
    
    // MARK: - UI

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

extension ReuseHeaderView {
    
    // MARK: - Instance method
    
    private func setViews() {
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(self)
            make.centerY.equalTo(self)
        }
    }
}
