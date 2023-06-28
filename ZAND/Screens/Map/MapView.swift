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
    
    private lazy var searchClosure = { [weak self] in
        AppRouter.shared.presentSearch(type: .search(self?.model ?? []), completion: { model in
            self?.showSinglePin(model: model.coordinates)
        })
    }
    
    // MARK: - Model
    
    var model: [SaloonMockModel]
    var currentModel: SaloonMockModel?
    
    // MARK: - Map
    
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    var rectangleOverlay: MKPolygon {
        return MKPolygon(coordinates: BaseMapRectModel.coordinates,
                         count: BaseMapRectModel.coordinates.count)
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
    }
    
    // MARK: - Map

    private func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
            mapView.addAnnotation(SaloonAnnotation(coordinate: coordinates,
                                                   model: $0))
        }
    }
    
    private func showSinglePin(model: String) {
        let bothCoordinates = model.components(separatedBy: ",")
        let coordinates = CLLocationCoordinate2D(latitude: Double(bothCoordinates[0] ) ?? 0,
                                                 longitude: Double(bothCoordinates[1] ) ?? 0)
        let region = MKCoordinateRegion(center: coordinates,
                                        span: MKCoordinateSpan(latitudeDelta: 0.01,
                                                               longitudeDelta: 0.01))
        if let myAnnotation = mapView.annotations.first(where: { $0.coordinate.latitude == coordinates.latitude }) {
            mapView.selectAnnotation(myAnnotation, animated: true)
        }
        mapView.setRegion(region, animated: true)
    }
    
    private func subscribeDelegate() {
        mapView.delegate = self
    }
    
    // MARK: - Action
    
    @objc
    private func navigateToSaloonDetail() {
        if let currentModel = currentModel {
            AppRouter.shared.push(.saloonDetail(currentModel))
        }
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
}

extension MapView: MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            var userAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: "user")
            userAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: "user")
            userAnnotation?.image = ImageAsset.fillCircle_icon
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
                annotationView?.image = ImageAsset.pin_icon
                let button = UIButton(type: .custom)
                button.setTitle(annotation.model.saloon_name, for: .normal)
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
            self.currentModel = customAnnotation.model as? SaloonMockModel
        }
    }
}