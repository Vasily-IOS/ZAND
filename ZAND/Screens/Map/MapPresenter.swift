//
//  MapPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import CoreLocation
import Combine

protocol MapPresenterOutput: AnyObject {
    var sortedSalons: [Saloon] { get set }
    var isZoomed: Bool? { get set }
    var distances: [DistanceModel] { get }

    func fetchCommonModel()
    func getSaloonModel(by id: Int) -> SaloonMapModel?
    func getDistance(by id: Int) -> String
}

protocol MapViewInput: AnyObject {
    func updateScale(isZoomed: Bool, userCoordinates: CLLocationCoordinate2D)
    func addPinsOnMap(from model: [SaloonMapModel])
    func updateUserLocation(isCanUpdate: Bool)
}

final class MapPresenter: MapPresenterOutput {

    // MARK: - Properties

    weak var view: MapViewInput?

    var sortedSalons: [Saloon] = []

    var distances: [DistanceModel] = []

    private var immutableSalons: [Saloon] = []

    var isZoomed: Bool? {
        didSet {
            guard let isZoomed,
                  let userCoordinates = userCoordinates else { return }

            calculateClosedSaloons(isClosed: isZoomed)
            view?.updateScale(isZoomed: isZoomed, userCoordinates: userCoordinates)
        }
    }

    private var userCoordinates: CLLocationCoordinate2D?

    private var cancellables = Set<AnyCancellable>()

    private let provider: SaloonProvider

    private let locationManager = DeviceLocationService.shared

    // MARK: - Initializers

    init(view: MapViewInput, provider: SaloonProvider) {
        self.view = view
        self.provider = provider

        subscribeNotifications()
        locationManager.requestLocationUpdates()
        bindUI()
    }

    // MARK: - Instance methods

    @objc
    private func connectivityStatus(_ notification: Notification) {
        if let isConnected = notification.userInfo?[Config.connectivityStatus] as? Bool {
            if isConnected {
                fetchCommonModel()
            }
        }
    }

    func fetchCommonModel() {
        provider.fetchData { [weak self] saloons in
            self?.sortedSalons = saloons
            self?.immutableSalons = saloons
            self?.view?.addPinsOnMap(from: saloons)
        }
    }

    func getSaloonModel(by id: Int) -> SaloonMapModel? {
        let model = sortedSalons.first(where: { $0.id == id })
        return model == nil ? nil : model
    }

    func getDistance(by id: Int) -> String {
        return distances.first(where: { $0.id == id})?.distanceInKilometers ?? ""
    }

    // MARK: - Private

    private func calculateClosedSaloons(isClosed: Bool) {
        if isClosed {
            sortedSalons = sortedSalonsByUserLocation()
        } else {
            sortedSalons = immutableSalons
        }
    }

    private func sortedSalonsByUserLocation() -> [Saloon] {
        guard let userCoordinates = userCoordinates else { return [] }

        let userLocation = CLLocation(latitude: userCoordinates.latitude, longitude: userCoordinates.longitude)
        var sortedSalons: [Saloon] = []

        for saloon in immutableSalons {
            let saloonLocation = CLLocation(
                latitude: saloon.coordinate_lat,
                longitude: saloon.coordinate_lon
            )

            let distanceToSaloon = userLocation.distance(from: saloonLocation)

            if distanceToSaloon <= 12000 {
                sortedSalons.append(saloon)

                let locationModel = DistanceModel(id: saloon.id, title: saloon.title, distance: distanceToSaloon)
                if !distances.contains(where: { $0.id == saloon.id}) {
                    distances.append(locationModel)
                }
            }
        }

        return sortedSalons
    }

    private func subscribeNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(connectivityStatus(_:)),
            name: .connecivityChanged, object: nil
        )
    }

    private func bindUI() {
        locationManager.currentLocation
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { [weak self] userCoordinates in
                guard let self else { return }

                self.userCoordinates = userCoordinates
                self.view?.updateUserLocation(isCanUpdate: true)

                if userCoordinates.latitude != self.userCoordinates?.latitude {
                    self.calculateClosedSaloons(isClosed: isZoomed ?? false)
                    self.view?.updateScale(isZoomed: isZoomed ?? false, userCoordinates: userCoordinates)
                }
            }.store(in: &cancellables)

        locationManager.deniedLocationAccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.view?.updateUserLocation(isCanUpdate: false)
            }.store(in: &cancellables)
    }
}
