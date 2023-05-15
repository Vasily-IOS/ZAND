//
//  MapView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import MapKit

final class MapView: BaseUIView {
    
    // MARK: - Closures
    
    private let searchClosure = {
        AppRouter.shared.present(type: .search)
    }
    
    // MARK: - Model
    
    var model: [SaloonMockModel]
    
    // MARK: - Map
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    var rectangleOverlay: MKPolygon {
        return MKPolygon(coordinates: BaseMapRectModel.coordinates, count: BaseMapRectModel.coordinates.count)
    }
    
    // MARK: - UI
    
    private lazy var searchButton = SearchButton(handler: searchClosure)
    
    // MARK: - Initializers
    
    init(model: [SaloonMockModel]) {
        self.model = model
        super.init(frame: .zero)
    }
    
    // MARK: - Instance methods
    
    override func setup() {
        super.setup()
        setBackgroundColor()
        setViews()
        
        setupLocationManager()
        setBaseOverlay()
        addPinsOnMap(model: model)
        subscribeDelegate()
        isLocationIsEnabled()
    }
    
    // MARK: - Map

    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    private func setBaseOverlay() {
        let region = MKCoordinateRegion(rectangleOverlay.boundingMapRect)
        mapView.setRegion(region, animated: true)
    }
    
    private func addPinsOnMap(model: [SaloonMockModel]) {
        model.forEach {
            let bothCoordinates = $0.coordinates.components(separatedBy: ",")
            let coordinates = CLLocationCoordinate2D(latitude: Double(bothCoordinates[0] ) ?? 0,
                                                  longitude: Double(bothCoordinates[1] ) ?? 0)
            mapView.addAnnotation(SaloonAnnotation(coordinate: coordinates))
        }
    }
    
    private func subscribeDelegate() {
        mapView.delegate = self
    }
    
    func showAlertLocation(title: String, message: String?, url: URL?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let settingsAction = UIAlertAction(title: "Title.settings.localized", style: .default) { alert in
            if let url = url {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "LocalizebleValues.cancel_sh.localized", style: .cancel)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
//        present(alertController, animated: true)
    }
}

extension MapView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubviews([searchButton, mapView])
        
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(self).offset(50)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(10)
            make.left.bottom.right.equalTo(self)
        }
    }
    
    private func setBackgroundColor() {
        backgroundColor = .mainGray
    }
    
    private func checkAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            showAlertLocation(title: "LocalizebleValues.denied_location.localized",
                              message: "LocalizebleValues.wanna_unlock_location.localized",
                              url: URL(string: UIApplication.openSettingsURLString))
            break
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            break
        @unknown default:
            break
        }
    }

    private func isLocationIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkAuthorization()
        } else {
            showAlertLocation(title: "LocalizebleValues.geoLoc_lock.localized",
                              message: "LocalizebleValues.wanna_unlock_geo.localized",
                              url: URL(string: UIApplication.openSettingsURLString))
        }
    }
}

extension MapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            var userAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: "user")
            userAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: "user")
            userAnnotation?.image = UIImage(named: "fillCircle_icon")
            return userAnnotation
        } else {
            if annotation is SaloonAnnotation {
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
                if annotationView == nil {
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
                    annotationView?.canShowCallout = true
                } else {
                    annotationView?.annotation = annotation
                }
                annotationView?.image = UIImage(named: "pin_icon")
                let button = UIButton(type: .custom)
                button.setTitle("Еуые", for: .normal)
                button.setTitleColor(.black, for: .normal)
//                button. (self, action: #selector(setTarget), for: .touchUpInside)
                annotationView?.detailCalloutAccessoryView = button
                return annotationView
            }
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
//        if let customAnnotation = view.annotation as? CityAnnotation {
//            self.pointModel = customAnnotation.pointModel
//        }
    }
}

extension MapView: CLLocationManagerDelegate {
    
    // MARK: - CLLocationManagerDelegate methods
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }
}
