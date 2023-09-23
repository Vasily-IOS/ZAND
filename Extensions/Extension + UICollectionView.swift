//
//  Extension + UICollectionViewCell.swift
//  ZAND
//
//  Created by Василий on 26.06.2023.
//

import UIKit

extension UICollectionView {

    // MARK: - Nested types

    enum Kind {
        case header
        case footer

        var viewType: String {
            switch self {
            case .header:
                return Config.header
            case .footer:
                return Config.footer
            }
        }
    }

    // MARK: - Cell

    func register<T: Reusable>(cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.reuseIdentifier)
    }

    func dequeueReusableCell<T: Reusable>(for indexPath: IndexPath, cellType: T.Type = T.self) -> T {
        guard let cell = dequeueReusableCell(
            withReuseIdentifier: cellType.reuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Failed to dequeue a cell with identifier \(cellType.reuseIdentifier) matching type \(cellType.self).")
        }
        return cell
    }

    // MARK: - Header/Footer

    func register<T: UICollectionReusableView>(view: T.Type) {
        register(T.self,
                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                 withReuseIdentifier: T.reuseIdentifier)
    }

    func dequeueReusableView<T: Reusable>(for indexPath: IndexPath, viewType: T.Type = T.self, kind: Kind) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: kind.viewType,
                                                          withReuseIdentifier: viewType.reuseIdentifier,
                                                          for: indexPath) as? T else {
            fatalError("Failed to dequeue a view with identifier \(viewType.reuseIdentifier) matching type \(viewType.self).")
        }
        return view
    }
}
