//
//  Reusable.swift
//  ZAND
//
//  Created by Василий on 26.06.2023.
//

import UIKit

protocol Reusable: AnyObject {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String { String(describing: self) }
}

extension UIView: Reusable { }
