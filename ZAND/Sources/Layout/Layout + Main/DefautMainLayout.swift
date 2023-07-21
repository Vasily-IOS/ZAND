//
//  DefautMainLayout.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import UIKit

protocol DefaultMainLayout: AnyObject {
    func createSection(type: MainSection) -> NSCollectionLayoutSection
}
