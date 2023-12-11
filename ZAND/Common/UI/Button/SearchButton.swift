//
//  BaseUIButton.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit

final class SearchButton: UIButton {
    
    // MARK: - Closure
    
    var tapHandler: (() -> Void)?
    
    // MARK: - Properties
    
    private let searchIcon = UIImageView(image: AssetImage.search_icon.image)
    private let searchLabel = UILabel(nil, .lightGray, AssetString.where_wanna_go.rawValue)
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        setViews()
        setSelf()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    
    @objc
    private func tapAction() {
        tapHandler?()
    }
}

extension SearchButton {

    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([searchIcon, searchLabel])
        
        self.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        
        searchIcon.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self)
        }
        
        searchLabel.snp.makeConstraints { make in
            make.left.equalTo(searchIcon.snp.right).offset(10)
            make.centerY.equalTo(self)
        }
    }
    
    private func setSelf() {
        layer.cornerRadius = 15
        backgroundColor = .white
        addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    }
}
