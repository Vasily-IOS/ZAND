//
//  DefaultSettingsLayout.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import UIKit

protocol DefaultSettingsLayout {
    func createSection(type: MyDetailsSection) -> NSCollectionLayoutSection
}
