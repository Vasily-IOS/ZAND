//
//  LayoutBuilder.swift
//  ZAND
//
//  Created by Василий on 21.04.2023.
//

import UIKit

enum MainSection: Int, CaseIterable {
    case option
    case beautySaloon
}

final class MainLayout: DefaultMainLayout {
    func createSection(type: MainSection) -> NSCollectionLayoutSection {
        switch type {
        case .option:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                  heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 0, leading: 0, bottom: 10, trailing: 10)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .absolute(85),
                heightDimension: .absolute(110)
            )
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            group.interItemSpacing = .fixed(10)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            return section
        case .beautySaloon:
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .fractionalHeight(1)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = .init(top: 10, leading: 0, bottom: 10, trailing: 0)

            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1),
                heightDimension: .estimated(333)
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: groupSize,
                subitems: [item]
            )
            group.interItemSpacing = .fixed(20)
            group.contentInsets = NSDirectionalEdgeInsets(
                top: 10, leading: 0,
                bottom: 10, trailing: 0
            )

            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(
                top: 0, leading: 0,
                bottom: 20, trailing: 0
            )
            return section
        }
    }
}
