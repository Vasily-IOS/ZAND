//
//  CommonModel.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation
import MapKit

protocol CommonModel {
    var id: Int { get }
    var coordinates: String { get }
    var saloon_name: String { get }
}
