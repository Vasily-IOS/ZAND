//
//  MapModel.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation
import MapKit

struct BaseMapRectModel {
    static let coordinates = [
        // Север (Долгопрудный)
        CLLocationCoordinate2D(latitude: 55.933310, longitude: 37.514188),
        // Юг (Дрожжино)
        CLLocationCoordinate2D(latitude: 55.527709, longitude: 37.593798),
        // Восток (Железнодорожный)
        CLLocationCoordinate2D(latitude: 55.746444, longitude: 38.009038),
        // Запад (Архангельское)
        CLLocationCoordinate2D(latitude: 55.789403, longitude: 37.301198)
    ]
}
