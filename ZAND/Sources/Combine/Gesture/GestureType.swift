//
//  GestureType.swift
//  ZAND.
//
//  Created by Василий on 24.07.2023.
//

import UIKit

enum GestureType {
    case tap(UITapGestureRecognizer = .init())
    case swipe(UISwipeGestureRecognizer = .init())
    case longPress(UILongPressGestureRecognizer = .init())
    case pan(UIPanGestureRecognizer = .init())
    case pinch(UIPinchGestureRecognizer = .init())
    case edge(UIScreenEdgePanGestureRecognizer = .init())

    func getType() -> UIGestureRecognizer {
        switch self {
        case let .tap(tapGesture): return tapGesture
        case let .swipe(swipeGesture): return swipeGesture
        case let .longPress(longPressGesture): return longPressGesture
        case let .pan(panGesture): return panGesture
        case let .pinch(pinchGesture): return pinchGesture
        case let .edge(edgePanGesture): return edgePanGesture
       }
    }
}
