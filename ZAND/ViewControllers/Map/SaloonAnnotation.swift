//
//  SaloonAnnotation.swift
//  ZAND
//
//  Created by Василий on 11.05.2023.
//

import Foundation
import MapKit

final class SaloonAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
//    var pointModel: PointsModel?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
//        self.pointModel =  pointModel
    }
}
