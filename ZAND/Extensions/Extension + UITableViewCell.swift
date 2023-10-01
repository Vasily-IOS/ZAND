//
//  UITableViewCell.swift
//  ZAND
//
//  Created by Василий on 13.04.2023.
//

import UIKit
import SnapKit

extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func separator(hide: Bool) {
        separatorInset.left = hide ? bounds.size.width : 0
    }
    
    func addLine() {
        let separator = UIView()
        separator.backgroundColor = .black.withAlphaComponent(0.2)
        contentView.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(self)
            make.height.equalTo(0.5)
        }
    }
}
