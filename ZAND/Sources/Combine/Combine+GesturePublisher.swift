//
//  Combine+GesturePublisher.swift
//  ZAND.
//
//  Created by Василий on 24.07.2023.
//

import UIKit

extension UIView {
    func gesture(_ type: GestureType) -> GesturePublisher {
        GesturePublisher(view: self, gestureType: type)
    }
}
