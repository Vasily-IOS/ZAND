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
    func showUser()
}

enum MapViewState {
    case performZoom(Bool, CLLocationCoordinate2D)
    case showSingle(CLLocationCoordinate2D)
}

final class MapRectView: BaseUIView {

    // MARK: - Nested types

    enum Pins: String {
        case saloon = "saloon"
        case user = "user"
    }

    enum Radius: Double {
        case closed = 15000.0
        case user = 6000.0
    }

    // MARK: - Properties

    weak var delegate: MapDelegate?

    private var currentId: Int?

    private var isShowSingle: Bool = false

    private var userCoordinate: CLLocationCoordinate2D?

    private var isCurrentLocationSelected: Bool = true {
        didSet {
            locationButton.backgroundColor = isCurrentLocationSelected ? .superLightGreen : .white
            locationButton.isUserInteractionEnabled = !isCurrentLocationSelected
        }
    }

    private lazy var onMapButton: UIButton = {
        let button = UIButton(configuration: .borderless())
        button.backgroundColor = .white
        button.setTitle(AssetString.near.rawValue, for: .normal)
        button.setTitleColor(.mainGreen, for: .normal)
        button.layer.cornerRadius = 15.0
        button.layer.borderColor = UIColor.mainGreen.cgColor
        button.layer.borderWidth = 2.0
        button.addTarget(self, action: #selector(dropScale), for: .touchUpInside)
        return button
    }()

    private let mapView = MKMapView()

    private let searchButton = SearchButton()

    private let locationButton: UIButton = {
        let button = UIButton()
        button.setImage(AssetImage.location_icon.image, for: .normal)
        button.backgroundColor = .superLightGreen
        button.layer.cornerRadius = 25
        return button
    }()

    // MARK: - Instance methods
    
    override func setup() {
        super.setup()

        setViews()
        subscribeDelegate()
        setupActions()
    }
    
    // MARK: - Public

    func configure(state: MapViewState) {
        switch state {
        case .performZoom(let isZoomed, let coordinates):
            onMapButton.backgroundColor = isZoomed ? .superLightGreen : .white
            onMapButton.setTitleColor(isZoomed ? .mainGreen : .black, for: .normal)
            userCoordinate = coordinates

            if isZoomed {
                mapView.setRegion(
                    MKCoordinateRegion(
                        center: coordinates,
                        latitudinalMeters: Radius.closed.rawValue,
                        longitudinalMeters: Radius.closed.rawValue
                    ),
                    animated: true
                )
            } else {
                let moscowCenter = CLLocationCoordinate2D(latitude: 55.7524903, longitude: 37.6232096)
                let span = MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8)
                let region = MKCoordinateRegion(center: moscowCenter , span: span)
                isCurrentLocationSelected = true
                mapView.setRegion(region, animated: true)
            }
            break
        case .showSingle(let coordinates):
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
    }

    // показывает локацию юзера
    func showUserLocation(_ coordinate: CLLocationCoordinate2D, willZoomToRegion: Bool) {
        isCurrentLocationSelected = true
        userCoordinate = coordinate

        // данная переменная служит индикатором показа точки юзера при первом входе
        if willZoomToRegion {
            self.mapView.setRegion(
                MKCoordinateRegion(
                    center: coordinate,
                    latitudinalMeters: Radius.user.rawValue,
                    longitudinalMeters: Radius.user.rawValue),
                animated: true
            )
        }
    }

    // добавляет точки на карту
    func addPinsOnMap(model: [Saloon]) {
        model.forEach {
            let coordinates = CLLocationCoordinate2D(
                latitude: $0.saloonCodable.coordinate_lat,
                longitude: $0.saloonCodable.coordinate_lon
            )
            mapView.addAnnotation(
                SaloonAnnotation(coordinate: coordinates, model: $0))
        }
    }

    // дает доступ на показ локации юзера
    func confirmShowUserLocation() {
        mapView.showsUserLocation = true
    }

    // MARK: - Private methods

    private func subscribeDelegate() {
        mapView.delegate = self
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

    @objc
    private func showUserOnMap() {
        delegate?.showUser()
    }
}

extension MapRectView {
    
    // MARK: - Instance methods
    
    private func setViews() {
        backgroundColor = .mainGray

        addSubviews([searchButton, mapView])
        mapView.addSubviews([onMapButton, locationButton])

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

        locationButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(16)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(24)
            make.width.height.equalTo(50)
        }
    }

    private func setupActions() {
        searchButton.tapHandler = { [weak self] in
            self?.delegate?.showSearch()
        }

        locationButton.addTarget(
            self,
            action: #selector(showUserOnMap),
            for: .touchUpInside
        )
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
                annotationView?.image = AssetImage.pin_icon.image
                let button = UIButton(type: .custom)
                button.setTitle(annotation.model.saloonCodable.title, for: .normal)
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
            self.currentId = customAnnotation.model.saloonCodable.id
        }
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        guard let userCoordinate else { return }

        let userLocation = CLLocation(
            latitude: userCoordinate.latitude,
            longitude: userCoordinate.longitude
        )
        let newLocation = CLLocation(
            latitude: mapView.region.center.latitude,
            longitude: mapView.region.center.longitude
        )

        isCurrentLocationSelected = userLocation.distance(from: newLocation) > 5 ? false : true
    }
}
