//
//  DefaultProfileLayout.swift
//  ZAND
//
//  Created by Василий on 27.04.2023.
//

import UIKit

enum ProfileSection: Int, CaseIterable {
    case profileFields
    case favourites
}

protocol DefaultProfileLayoutProtocol {
    func createSection(type: ProfileSection) -> NSCollectionLayoutSection
}
