//
//  SearchView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import SnapKit

final class DefaultSearchView: BaseUIView {
    
    // MARK: - Properties
    
    private let searchIcon = UIImageView(image: UIImage(named: "search_icon"))
    private let searchTextField: UITextField = {
        let searchTextField = UITextField()
        searchTextField.placeholder = Strings.where_wanna_go
        return searchTextField
    }()
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setSelf()
        setViews()
    }
}

extension DefaultSearchView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([searchIcon, searchTextField])
        
        searchIcon.snp.makeConstraints { make in
            make.left.equalTo(self).offset(10)
            make.centerY.equalTo(self)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.left.equalTo(searchIcon.snp.right).offset(10)
            make.centerY.equalTo(self)
        }
    }
    
    private func setSelf() {
        self.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
        self.layer.cornerRadius = 15.0
    }
}
