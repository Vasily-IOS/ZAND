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
    var saloonMockModel: SaloonMockModel?=nil
    
    init(coordinate: CLLocationCoordinate2D, saloonMockModel: SaloonMockModel? = nil) {
        self.coordinate = coordinate
        self.saloonMockModel = saloonMockModel
    }
}
