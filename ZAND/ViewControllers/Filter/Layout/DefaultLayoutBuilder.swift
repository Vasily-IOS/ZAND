//
//  DefaultLayoutBuilder.swift
//  ZAND
//
//  Created by Василий on 24.04.2023.
//

import UIKit

protocol DefaultLayoutBuilder: AnyObject {
    func createSection(type: FilterSection) -> NSCollectionLayoutSection
}
