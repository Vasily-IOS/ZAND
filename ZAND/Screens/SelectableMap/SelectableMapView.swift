//
//  SelectableView.swift
//  ZAND
//
//  Created by Василий on 22.05.2023.
//

import UIKit
import MapKit
import SnapKit

final class SelectableMapView: BaseUIView {
    
    // MARK: - Properties
    
    var presenter: SelectablePresenterProtocol?
    
    // MARK: - Map
    
    private let mapView = MKMapView()
    
    // MARK: - Initializers
    
    init(model: CommonModel) {
        super.init(frame: .zero)
        addPinsOnMap(model: model)
    }

    // MARK: - Instance methods

    override func setup() {
        super.setup()
        setViews()
        subscribeDelegate()
    }
    
    // MARK: - Map
    
    private func addPinsOnMap(model: CommonModel) {
        let bothCoordinates = model.coordinates.components(separatedBy: ",")
        let coordinates = CLLocationCoordinate2D(latitude: Double(bothCoordinates[0] ) ?? 0,
                                                 longitude: Double(bothCoordinates[1] ) ?? 0)
        let annotation = SaloonAnnotation(coordinate: coordinates, model: model)
        annotation.title = model.saloon_name
        mapView.addAnnotation(annotation)
        mapView.selectAnnotation(annotation, animated: true)
        mapView.showAnnotations(self.mapView.annotations, animated: true)
    }
    
    private func subscribeDelegate() {
        mapView.delegate = self
    }
}

extension SelectableMapView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        addSubview(mapView)
        
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}

extension SelectableMapView: MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate methods
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is SaloonAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            } else {
                annotationView?.annotation = annotation
            }
            annotationView?.image = ImageAsset.pin_icon
            annotationView?.canShowCallout = true
            return annotationView
        }
        return nil
    }
}

extension SelectableMapView: SelectableViewProtocol {}
