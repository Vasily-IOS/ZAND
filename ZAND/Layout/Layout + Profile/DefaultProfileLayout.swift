//
//  DefaultProfileLayout.swift
//  ZAND
//
//  Created by Василий on 27.04.2023.
//

import UIKit

protocol DefaultProfileLayout {
    func createSection(type: ProfileSection) -> NSCollectionLayoutSection?
}
