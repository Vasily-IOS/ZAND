//
//  TimetableLayout.swift
//  ZAND
//
//  Created by Василий on 26.09.2023.
//

import UIKit

enum TimetableSection: Int, CaseIterable {
    case day
    case time
}

final class TimetableLayout: DefaultTimetableLayout {
    func createSection(type: TimetableSection) -> NSCollectionLayoutSection? {
        switch type {
        case .day:
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 10)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(70),
                heightDimension: .absolute(95))

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(10)

            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous

            return section
        case .time:
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(44)
            )
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )

            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.2),
                heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 10)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.2))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            section.boundarySupplementaryItems = [header]
            return section
        }
    }
}
