//
//  Config.swift
//  ZAND
//
//  Created by Василий on 26.06.2023.
//

import Foundation

enum Config {
    static let header = "UICollectionElementKindSectionHeader"
    static let footer = "UICollectionElementKindSectionFooter"
    // annotations
    static let customAnnotation = "customAnnotation"
    static let userAnnotation = "userAnnotation"
    // animation
    static let animation_fav = "animation_fav"
    static let animation_entryConfimed = "animation_entryConfimed"
    static let animation_entryNoConfirmed = "animation_entryNoConfirmed"
    static let animation_noInternet = "animation_noInternet"
    // connectivity status
    static let connectivityStatus = "connectivityStatus"
    static let splash_video = "splash_video"
    static let splash_video_type = "mp4"
    // other
    static let token = "currentBearerToken"
    static let undeletableUserKey = "undeletableUserKey"
}
