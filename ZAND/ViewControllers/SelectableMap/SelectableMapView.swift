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
    
    init(coordinates: String) {
        super.init(frame: .zero)
        addPinsOnMap(model: coordinates)
    }

    // MARK: - Instance methods

    override func setup() {
        super.setup()
        setViews()
        subscribeDelegate()
    }
    
    // MARK: - Map
    
    private func addPinsOnMap(model: String) {
        let bothCoordinates = model.components(separatedBy: ",")
        let coordinates = CLLocationCoordinate2D(latitude: Double(bothCoordinates[0] ) ?? 0,
                                                 longitude: Double(bothCoordinates[1] ) ?? 0)
        mapView.addAnnotation(SaloonAnnotation(coordinate: coordinates))
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is SaloonAnnotation {
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            } else {
                annotationView?.annotation = annotation
            }
            annotationView?.image = UIImage(named: "pin_icon")
            return annotationView
        }
        return nil
    }
}

extension SelectableMapView: SelectableViewProtocol {}
