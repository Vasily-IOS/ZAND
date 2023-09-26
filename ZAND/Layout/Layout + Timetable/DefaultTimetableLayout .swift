//
//  DefaultTimetableLayout .swift
//  ZAND
//
//  Created by Василий on 26.09.2023.
//

import UIKit

protocol DefaultTimetableLayout {
    func createSection(type: TimetableSection) -> NSCollectionLayoutSection?
}
