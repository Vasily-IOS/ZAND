//
//  SaloonAnnotation.swift
//  ZAND
//
//  Created by Василий on 11.05.2023.
//

import Foundation
import MapKit

final class SaloonAnnotation: NSObject, MKAnnotation {

    // MARK: - Public properties

    var coordinate: CLLocationCoordinate2D
    var model: Saloon
    var title: String?

    // MARK: - Initializers

    init(coordinate: CLLocationCoordinate2D, model: Saloon) {
        self.coordinate = coordinate
        self.model = model
    }
}
