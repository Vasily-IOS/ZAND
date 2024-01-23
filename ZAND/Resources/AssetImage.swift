//
//  ImageAsset.swift
//  ZAND
//
//  Created by Василий on 22.05.2023.
//

import UIKit

enum AssetImage {
    case main_icon
    case map_icon
    case profile_icon
    case pin_icon
    case line_icon
    case emptyCircle_icon
    case like_icon
    case star_icon
    case fav_icon
    case fillCircle_icon
    case checkMark_icon
    case back_icon
    case books_icon
    case settings_icon
    case logout_icon
    case heart_icon
    case fillHeart_icon
    case search_icon
    case noFoto_icon
    case start_booking_service_icon
    case start_booking_specialist_icon
    case arrow_icon
    case lostConnection_icon
    case deleteProfile_icon
    case location_icon
    case delete_icon
    case trash

    var image: UIImage {
        switch self {
        case .main_icon:
            return UIImage(named: "main_icon")!
        case .map_icon:
            return UIImage(named: "map_icon")!
        case .profile_icon:
            return UIImage(named: "profile_icon")!
        case .pin_icon:
            return UIImage(named: "pin_icon")!
        case .line_icon:
            return UIImage(named: "line_icon")!
        case .emptyCircle_icon:
            return UIImage(named: "emptyCircle_icon")!
        case .like_icon:
            return UIImage(named: "like_icon")!
        case .star_icon:
            return UIImage(named: "star_icon")!
        case .fav_icon:
            return UIImage(named: "fav_icon")!
        case .fillCircle_icon:
            return UIImage(named: "fillCircle_icon")!
        case .checkMark_icon:
            return UIImage(named: "checkMark_icon")!
        case .back_icon:
            return UIImage(named: "back_icon")!
        case .books_icon:
            return UIImage(named: "books_icon")!
        case .settings_icon:
            return UIImage(named: "settings_icon")!
        case .logout_icon:
            return UIImage(named: "logout_icon")!
        case .heart_icon:
            return UIImage(named: "heart_icon")!
        case .fillHeart_icon:
            return UIImage(named: "fill_heart_icon")!
        case .search_icon:
            return UIImage(named: "search_icon")!
        case .noFoto_icon:
            return UIImage(named: "noFoto_icon")!
        case .start_booking_service_icon:
            return UIImage(named: "start_booking_service_icon")!
        case .start_booking_specialist_icon:
            return UIImage(named: "start_booking_specialist_icon")!
        case .arrow_icon:
            return UIImage(named: "arrow_icon")!
        case .lostConnection_icon:
            return UIImage(named: "lost_connection_icon")!
        case .deleteProfile_icon:
            return UIImage(named: "deleteProfile_icon")!
        case .location_icon:
            return UIImage(named: "location_icon")!
        case .delete_icon:
            return UIImage(named: "delete_icon")!
        case .trash:
            return UIImage(named: "trash_icon")!
        }
    }
}
