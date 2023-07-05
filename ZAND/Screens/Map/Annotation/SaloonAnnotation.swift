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
    var model: CommonModel
    var title: String?

    // MARK: - Initializers

    init(coordinate: CLLocationCoordinate2D, model: CommonModel) {
        self.coordinate = coordinate
        self.model = model
    }
}
