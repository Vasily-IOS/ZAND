//
//  SaloonModel.swift
//  ZAND
//
//  Created by Василий on 23.11.2023.
//

import CoreLocation

protocol Saloon {
    var saloonCodable: SaloonCodableModel { get }
    var distance: CLLocationDistance? { get set }
    var distanceString: String? { get }
}

struct SaloonModel: Saloon, Hashable {
    var saloonCodable: SaloonCodableModel
    var distance: CLLocationDistance?
    var distanceString: String? {
        return String(format: "%.3f", (Double(distance ?? 0.0 / 1000)) / 1000) + " " + "км"
    }
}
