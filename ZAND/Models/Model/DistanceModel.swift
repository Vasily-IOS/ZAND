//
//  LocationModel.swift
//  ZAND
//
//  Created by Василий on 21.11.2023.
//

import CoreLocation

struct DistanceModel: Hashable {
    let id: Int
    let title: String
    let distance: CLLocationDistance

    var distanceInKilometers: String {
        return String(format: "%.3f", Double(distance / 1000))
    }
}
