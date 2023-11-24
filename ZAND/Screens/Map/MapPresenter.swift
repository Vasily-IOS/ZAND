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
    var immutableSalons: [Saloon] { get }
    var isZoomed: Bool? { get set }

    func fetchCommonModel()
    func getSaloonModel(by id: Int) -> Saloon?
    func showUser()
}

protocol MapViewInput: AnyObject {
    func updateScale(isZoomed: Bool, userCoordinates: CLLocationCoordinate2D)
    func addPinsOnMap(from model: [Saloon])
    func updateUserLocation(isCanUpdate: Bool)
    func showUser(coordinate: CLLocationCoordinate2D, willZoomToRegion: Bool)
}

final class MapPresenter: MapPresenterOutput {

    // MARK: - Properties

    weak var view: MapViewInput?

    var sortedSalons: [Saloon] = []

    var immutableSalons: [Saloon] = []

    var isZoomed: Bool? {
        didSet {
            guard let isZoomed,
                  let userCoordinates = userCoordinates else { return }

            view?.updateScale(isZoomed: isZoomed, userCoordinates: userCoordinates)
        }
    }

    private var isShowUserPoint: Bool = false

    private var userCoordinates: CLLocationCoordinate2D? {
        didSet {
            calculateNearestSalons()
        }
    }

    private var cancellables = Set<AnyCancellable>()

    private let provider: SaloonProvider

    private let locationManager = DeviceLocationService.shared

    // MARK: - Initializers

    init(view: MapViewInput, provider: SaloonProvider) {
        self.view = view
        self.provider = provider

        subscribeNotifications()
        locationManager.requestLocationUpdates()
        bind()
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
            guard let self else { return }

            self.immutableSalons = saloons
            self.view?.addPinsOnMap(from: saloons)
        }
    }

    func getSaloonModel(by id: Int) -> Saloon? {
        let salons = (isZoomed ?? true) ? sortedSalons : immutableSalons
        let model = salons.first(where: { $0.saloonCodable.id == id })
        return model == nil ? nil : model
    }

    func showUser() {
        if let userCoordinates = userCoordinates {
            view?.showUser(coordinate: userCoordinates, willZoomToRegion: isShowUserPoint)
        }
        isShowUserPoint = true
    }

    // MARK: - Private

    private func calculateNearestSalons() {
        sortedSalons = sortedSalonsByUserLocation()
    }

    private func sortedSalonsByUserLocation() -> [Saloon] {
        guard let userCoordinates = userCoordinates else { return [] }

        let currentUserLocation = CLLocation(
            latitude: userCoordinates.latitude,
            longitude: userCoordinates.longitude
        )

        sortedSalons = immutableSalons.map { saloon in
            let saloonDistance = CLLocation(
                latitude: saloon.saloonCodable.coordinate_lat,
                longitude: saloon.saloonCodable.coordinate_lon
            )

            return SaloonModel(
                saloonCodable: saloon.saloonCodable,
                distance: currentUserLocation.distance(from: saloonDistance)
            )
        }.filter { ($0.distance ?? 0.0) <= 12000 }

        return sortedSalons
    }

    private func subscribeNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(connectivityStatus(_:)),
            name: .connecivityChanged, object: nil
        )
    }

    private func bind() {
        locationManager.currentLocation
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { _ in }) { [weak self] userCoordinates in
                guard let self else { return }

                self.userCoordinates = userCoordinates
                self.view?.updateUserLocation(isCanUpdate: true)
            }.store(in: &cancellables)

        locationManager.deniedLocationAccess
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.view?.updateUserLocation(isCanUpdate: false)
            }.store(in: &cancellables)
    }
}
