//
//  MapView.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import MapKit
import SnapKit

protocol MapDelegate: AnyObject {
    func showSearch()
    func showDetail(by id: Int)
    func changeScale()
}

final class MapRectView: BaseUIView {

    // MARK: - Nested types

    enum Pins: String {
        case saloon = "saloon"
        case user = "user"
    }

    // MARK: - Properties

    weak var delegate: MapDelegate?

    private var currentId: Int?

    private lazy var onMapButton: UIButton = {
        let button = UIButton(configuration: .borderless())
        button.backgroundColor = .white
        button.setTitle("Ближайшие", for: .normal)
        button.setTitleColor(.mainGreen, for: .normal)
        button.layer.cornerRadius = 15.0
        button.layer.borderColor = UIColor.mainGreen.cgColor
        button.layer.borderWidth = 2.0
        button.addTarget(self, action: #selector(dropScale), for: .touchUpInside)
        return button
    }()

    private var defaultOverlay: MKPolygon {
        return MKPolygon(
            coordinates: BaseMapRectModel.coordinates,
            count: BaseMapRectModel.coordinates.count
        )
    }

    private let mapView = MKMapView()

    private let searchButton = SearchButton()

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
        subscribeDelegate()
        searchAction()
    }
    
    // MARK: - Public

    func configure(isZoomed: Bool, userCoordinates: CLLocationCoordinate2D) {
        onMapButton.backgroundColor = isZoomed ? .superLightGreen : .white
        onMapButton.setTitleColor(isZoomed ? .mainGreen : .black, for: .normal)

        if isZoomed {
            mapView.setRegion(
                MKCoordinateRegion(
                    center: userCoordinates,
                    latitudinalMeters: 15000,
                    longitudinalMeters: 15000
                ),
                animated: true
            )

        } else {
            mapView.setRegion(
                MKCoordinateRegion(defaultOverlay.boundingMapRect), animated: true
            )
        }
    }

    func addPinsOnMap(model: [SaloonMapModel]) {
        model.forEach {
            let coordinates = CLLocationCoordinate2D(
                latitude: $0.coordinate_lat,
                longitude: $0.coordinate_lon
            )
            mapView.addAnnotation(
                SaloonAnnotation(coordinate: coordinates, model: $0))
        }
    }

    func showSinglePin(coordinate_lat: Double, coordinate_lon: Double) {
        let coordinates = CLLocationCoordinate2D(
            latitude: coordinate_lat,
            longitude: coordinate_lon
        )
        let region = MKCoordinateRegion(
            center: coordinates,
            span: MKCoordinateSpan(
                latitudeDelta: 0.01,
                longitudeDelta: 0.01
            )
        )
        if let myAnnotation = mapView.annotations.first(
            where: { $0.coordinate.latitude == coordinates.latitude }
        ) {
            mapView.selectAnnotation(myAnnotation, animated: true)
        }
        mapView.setRegion(region, animated: true)
    }

    func showUserLocation() {
        mapView.showsUserLocation = true
    }

    // MARK: - Private methods

    private func subscribeDelegate() {
        mapView.delegate = self
    }

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

    @objc
    private func dropScale() {
        delegate?.changeScale()
    }
}

extension MapRectView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        backgroundColor = .mainGray

        addSubviews([searchButton, mapView])
        mapView.addSubview(onMapButton)

        searchButton.snp.makeConstraints { make in
            make.top.equalTo(self).offset(50)
            make.left.equalTo(self).offset(16)
            make.right.equalTo(self).inset(16)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(10)
            make.left.bottom.right.equalTo(self)
        }

        onMapButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(16)
            make.top.equalToSuperview().offset(16)
            make.height.equalTo(48)
        }
    }
}

extension MapRectView: MKMapViewDelegate {
    
    // MARK: - MKMapViewDelegate methods

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            var userAnnotation = mapView.dequeueReusableAnnotationView(
                withIdentifier: Pins.user.rawValue
            )
            userAnnotation = UserAnnotation(
                annotation: annotation, reuseIdentifier: Pins.user.rawValue
            )
            return userAnnotation
        } else {
            if let annotation = annotation as? SaloonAnnotation {
                var annotationView = mapView.dequeueReusableAnnotationView(
                    withIdentifier: Pins.saloon.rawValue
                )
                if annotationView == nil {
                    annotationView = MKAnnotationView(
                        annotation: annotation,
                        reuseIdentifier: Pins.saloon.rawValue
                    )
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
