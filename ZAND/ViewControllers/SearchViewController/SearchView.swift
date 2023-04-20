//
//  SearchView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit

final class SearchView: BaseUIView {
    
    // MARK: - Properties
    
    private let defaultSearchView = DefaultSearchView()
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setBackgroundColor()
        setViews()
    }
}

extension SearchView {
    
    private func setViews() {
        addSubviews([defaultSearchView])
        
        defaultSearchView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
        }
    }
    
    private func setBackgroundColor() {
        backgroundColor = .mainGray
    }
}
