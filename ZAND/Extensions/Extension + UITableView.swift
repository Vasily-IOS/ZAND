//
//  UITableView.swift
//  ZAND
//
//  Created by Василий on 13.04.2023.
//

import UIKit

public extension UITableView {
    
    func registerCell(type: UITableViewCell.Type, identifier: String? = nil) {
        let cellId = String(describing: type)
        register(type, forCellReuseIdentifier: identifier ?? cellId)
    }
    
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type) -> T? {
        return dequeueReusableCell(withIdentifier: type.identifier) as? T
    }

    func registerHeaderFooter(type: UITableViewHeaderFooterView.Type, identifier: String? = nil) {
        let headerFooterId = String(describing: type)
        register(type, forHeaderFooterViewReuseIdentifier: identifier ?? headerFooterId)
    }
    
    func dequeueHeader<T: UITableViewHeaderFooterView>(withType type: UITableViewHeaderFooterView.Type) -> T? {
        return dequeueReusableHeaderFooterView(withIdentifier: type.identifier) as? T
    }

    func dequeueCell<T: UITableViewCell>(withType type: T.Type = T.self, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: type.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(type.reuseIdentifier) matching type \(type.self).")
        }
        return cell
    }
}
