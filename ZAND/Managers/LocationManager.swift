//
//  LocationManager.swift
//  ZAND
//
//  Created by Василий on 19.11.2023.
//

import Combine
import CoreLocation
import YandexMobileMetrica

final class LocationManager: NSObject, CLLocationManagerDelegate {

    // MARK: - Properties

    static let shared = LocationManager()

    var currentLocation = PassthroughSubject<CLLocationCoordinate2D, Error>()

    // пока не используется, но я думаю понадобится позже
    var deniedLocationAccess = PassthroughSubject<Void, Never>()

    private override init() {
        super.init()
    }

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()

    // MARK: - Instance methods

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            locationManager.stopUpdatingLocation()
            deniedLocationAccess.send()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation.send(location.coordinate)
        // отправляем эвент о локации юзера
        YMMYandexMetrica.setLocation(location)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        currentLocation.send(completion: .failure(error))
    }

    func requestLocationUpdates() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        default:
            deniedLocationAccess.send()
        }
    }
}
