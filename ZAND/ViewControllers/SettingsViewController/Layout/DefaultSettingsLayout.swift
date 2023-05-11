//
//  DefaultSettingsLayout.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import UIKit

enum SettingsState: Int, CaseIterable {
    case data
    case pushes
}

protocol DefaultSettingsLayout {
    func createSection(type: SettingsState) -> NSCollectionLayoutSection
}
