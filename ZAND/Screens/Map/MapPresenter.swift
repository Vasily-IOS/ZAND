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
    var allSalons: [Saloon] { get }
    var mapState: SearchState? { get set }

    func fetchCommonModel()
    func getSaloonModel(by id: Int) -> Saloon?
    func showUser()
    func sortedSalonsByUserLocation() -> [Saloon]
}

protocol MapViewInput: AnyObject {
    func updateScale(state: SearchState, isShouldZoom: Bool?, coordinates: CLLocationCoordinate2D?)
    func addPinsOnMap(from model: [Saloon])
    func updateUserLocation(isCanUpdate: Bool)
    func showUser(coordinate: CLLocationCoordinate2D, willZoomToRegion: Bool)
}

enum SearchState: Equatable {
    case near
    case all
    case saloonZoom(Int?=0, latitude: Double, longtitude: Double)
    case none
}

final class MapPresenter: MapPresenterOutput {

    // MARK: - Properties

    weak var view: MapViewInput?

    var sortedSalons: [Saloon] = []

    var allSalons: [Saloon] = []

    var mapState: SearchState? {
        didSet {
            guard let mapState,
                  let userCoordinates = userCoordinates else { return }

            switch mapState {
            case let .saloonZoom(stateIndex, _, _):
                self.mapState = stateIndex == 0 ? .near : .all

                view?.updateScale(
                    state: mapState,
                    isShouldZoom: nil,
                    coordinates: nil
                )
            case .near, .all:
                self.mapState = mapState

                view?.updateScale(
                    state: mapState,
                    isShouldZoom: mapState == .near ? true : false,
                    coordinates: userCoordinates
                )
            default:
                break
            }
        }
    }

    // данная переменная служит индикатором показа точки юзера при первом входе
    private var isShowUserPoint: Bool = false

    private var userCoordinates: CLLocationCoordinate2D? {
        didSet {
            calculateNearestSalons()
        }
    }

    private var cancellables = Set<AnyCancellable>()

    private let provider: SaloonProvider

    private let locationManager = LocationManager.shared

    // MARK: - Initializers

    init(view: MapViewInput, provider: SaloonProvider) {
        self.view = view
        self.provider = provider

        self.subscribeNotifications()
        self.locationManager.requestLocationUpdates()
        self.bind()
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

            self.allSalons = saloons
            self.view?.addPinsOnMap(from: saloons)
        }
    }

    func getSaloonModel(by id: Int) -> Saloon? {
        let isSortedSaloonContains = sortedSalons.contains(where: { $0.saloonCodable.id == id })

        return isSortedSaloonContains ? sortedSalons.first(where: { $0.saloonCodable.id == id }) :
        allSalons.first(where: { $0.saloonCodable.id == id })
    }

    func showUser() {
        if let userCoordinates = userCoordinates {
            view?.showUser(coordinate: userCoordinates, willZoomToRegion: isShowUserPoint)
        }
        isShowUserPoint = true
    }

    func calculateNearestSalons() {
        sortedSalons = sortedSalonsByUserLocation()
    }

    func sortedSalonsByUserLocation() -> [Saloon] {
        guard let userCoordinates = userCoordinates else { return [] }

        let currentUserLocation = CLLocation(
            latitude: userCoordinates.latitude,
            longitude: userCoordinates.longitude
        )

        sortedSalons = allSalons.map { saloon in
            let saloonDistance = CLLocation(
                latitude: saloon.saloonCodable.latitude,
                longitude: saloon.saloonCodable.longitude
            )

            return SaloonModel(
                saloonCodable: saloon.saloonCodable,
                distance: currentUserLocation.distance(from: saloonDistance)
            )
        }.filter { ($0.distance ?? 0.0) <= 12000 }

        return sortedSalons
    }

    // MARK: - Private

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
