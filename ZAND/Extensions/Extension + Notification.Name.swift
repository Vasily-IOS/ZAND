//
//  Extension + Notification.Name.swift
//  ZAND
//
//  Created by Василий on 05.07.2023.
//

import Foundation

extension Notification.Name {
    static let isInFavourite = Notification.Name(rawValue: "isInFavourite")
    static let showTabBar = Notification.Name(rawValue: "notifyTabBar")
    static let connecivityChanged = Notification.Name(rawValue: "connecivityChanged")
    static let showBadRequestScreen = Notification.Name(rawValue: "showBadRequestScreen")
    static let storageIDidChanged = Notification.Name(rawValue: "storageIDidChanged")
}
