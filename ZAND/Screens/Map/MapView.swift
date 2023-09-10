//
//  MapView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import MapKit

protocol MapDelegate: AnyObject {
    func showSearch()
    func showDetail(by id: Int)
}

final class MapView: BaseUIView {

    // MARK: - Properties

    weak var delegate: MapDelegate?

    var currentId: Int?

    var rectangleOverlay: MKPolygon {
        return MKPolygon(coordinates: BaseMapRectModel.coordinates,
                         count: BaseMapRectModel.coordinates.count)
    }

    private let searchButton = SearchButton()
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
        setupLocationManager()
        setBaseOverlay()
        subscribeDelegate()
        searchAction()
    }
    
    // MARK: - 

    func addPinsOnMap(model: [SaloonMapModel]) {
        model.forEach {
//            let bothCoordinates = $0.coordinates.components(separatedBy: ",")
//            let coordinates = CLLocationCoordinate2D(latitude: Double(bothCoordinates[0] ) ?? 0,
//                                                  longitude: Double(bothCoordinates[1] ) ?? 0)
            let coordinates = CLLocationCoordinate2D(
                latitude: $0.coordinate_lat,
                longitude: $0.coordinate_lon
            )
            mapView.addAnnotation(SaloonAnnotation(coordinate: coordinates,
                                                   model: $0))
        }
    }

//    func showSinglePin(model: String) {
//        let bothCoordinates = model.components(separatedBy: ",")
//        let coordinates = CLLocationCoordinate2D(latitude: Double(bothCoordinates[0] ) ?? 0,
//                                                 longitude: Double(bothCoordinates[1] ) ?? 0)
//        let region = MKCoordinateRegion(center: coordinates,
//                                        span: MKCoordinateSpan(latitudeDelta: 0.01,
//                                                               longitudeDelta: 0.01))
//        if let myAnnotation = mapView.annotations.first(where: { $0.coordinate.latitude == coordinates.latitude }) {
//            mapView.selectAnnotation(myAnnotation, animated: true)
//        }
//        mapView.setRegion(region, animated: true)
//    }

    func showSinglePin(coordinate_lat: Double, coordinate_lon: Double) {
        let coordinates = CLLocationCoordinate2D(latitude: coordinate_lat,
                                                 longitude: coordinate_lon)
        let region = MKCoordinateRegion(center: coordinates,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                               longitudeDelta: 0.01))
        if let myAnnotation = mapView.annotations.first(where: { $0.coordinate.latitude == coordinates.latitude }) {
            mapView.selectAnnotation(myAnnotation, animated: true)
        }
        mapView.setRegion(region, animated: true)
    }

    // MARK: -

    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func subscribeDelegate() {
        mapView.delegate = self
    }

    private func setBaseOverlay() {
        let region = MKCoordinateRegion(rectangleOverlay.boundingMapRect)
        mapView.setRegion(region, animated: true)
    }
    
    // MARK: - Action

    private func searchAction() {
        searchButton.tapHandler = { [weak self] in
            self?.delegate?.showSearch()
        }
    }
    
    @objc
    private func navigateToSaloonDetail() {
        guard let id = currentId  else { return }

        delegate?.showDetail(by: id)
    }
}

extension MapView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        backgroundColor = .mainGray

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
}

extension MapView: MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            var userAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: "user")
            userAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: "user")
            userAnnotation?.image = AssetImage.fillCircle_icon
            return userAnnotation
        } else {
            if let annotation = annotation as? SaloonAnnotation {
                var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
                if annotationView == nil {
                    annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
                    annotationView?.canShowCallout = true
                } else {
                    annotationView?.annotation = annotation
                }
                annotationView?.image = AssetImage.pin_icon
                let button = UIButton(type: .custom)
                button.setTitle(annotation.model.title, for: .normal)
                button.setTitleColor(.black, for: .normal)
                button.addTarget(self, action: #selector(navigateToSaloonDetail), for: .touchUpInside)
                annotationView?.detailCalloutAccessoryView = button
                return annotationView
            }
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let customAnnotation = view.annotation as? SaloonAnnotation {
            self.currentId = customAnnotation.model.id
        }
    }
}
