//
//  LocationManager.swift
//  ZAND
//
//  Created by Василий on 11.05.2023.
//

import UIKit
import MapKit

final class LocationManager: DefaultLocationManager {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()

    private init() {}
    
    var appDelegate: AppDelegate? {
        didSet {
            
        }
    }
}

extension LocationManager {
    
    private func isLocationIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkAuthorization()
        } else {
//            showAlertLocation(title: "LocalizebleValues.geoLoc_lock.localized",
//                              message: "LocalizebleValues.wanna_unlock_geo.localized",
//                              url: URL(string: UIApplication.openSettingsURLString))
        }
    }
    
    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.delegate = self
    }
    
    private func checkAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
//            showAlertLocation(title: "LocalizebleValues.denied_location.localized",
//                              message: "LocalizebleValues.wanna_unlock_location.localized",
//                              url: URL(string: UIApplication.openSettingsURLString))
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
//            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        @unknown default:
            break
        }
    }
    
}

//extension LocationManager: CLLocationManagerDelegate {
////
////    // MARK: - CLLocationManagerDelegate methods
////
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        checkAuthorization()
//    }
//}
