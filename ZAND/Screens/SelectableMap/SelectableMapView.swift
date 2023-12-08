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

    private let mapView = MKMapView()

    // MARK: - Instance methods

    override func setup() {
        super.setup()
        
        setViews()
        subscribeDelegate()
    }

    func addPinOnMap(model: Saloon) {
        let coordinates = CLLocationCoordinate2D(
            latitude: model.saloonCodable.coordinate_lat,
            longitude: model.saloonCodable.coordinate_lon
        )
        let annotation = SaloonAnnotation(coordinate: coordinates, model: model)
        annotation.title = model.saloonCodable.title
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
            var annotationView = mapView.dequeueReusableAnnotationView(
                withIdentifier: Config.customAnnotation
            )
            if annotationView == nil {
                annotationView = MKAnnotationView(
                    annotation: annotation,
                    reuseIdentifier: Config.customAnnotation)
            } else {
                annotationView?.annotation = annotation
            }
            annotationView?.image = AssetImage.pin_icon.image
            annotationView?.canShowCallout = true
            return annotationView
        }
        return nil
    }
}
