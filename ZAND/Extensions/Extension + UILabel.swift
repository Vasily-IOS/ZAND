//
//  UILabel.swift
//  ZAND
//
//  Created by Василий on 13.04.2023.
//

import UIKit

extension UILabel {
    convenience init(
        _ fontSize: UIFont? = nil,
        _ colorOfText: UIColor? = nil,
        _ title: String? = nil
    ) {
        self.init()
        font = fontSize
        textColor = colorOfText
        text = title
    }
}

