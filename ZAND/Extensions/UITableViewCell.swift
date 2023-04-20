//
//  UITableViewCell.swift
//  ZAND
//
//  Created by Василий on 13.04.2023.
//

import UIKit

extension UITableViewCell {
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func separator(hide: Bool) {
        separatorInset.left = hide ? bounds.size.width : 0
    }
}
