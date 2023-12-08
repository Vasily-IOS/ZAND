//
//  MainPresenter.swift
//  ZAND
//
//  Created by Василий on 07.06.2023.
//

import Combine
import CoreLocation

enum MainType {
    case options
    case saloons
}

protocol MainPresenterOutput: AnyObject {
    var sortedSaloons: [Saloon] { get set }
    var allSalons: [Saloon] { get }

    var selectedFilters: [IndexPath: Bool] { get set }
    var isFirstLaunch: Bool { get set }
    var state: SearchState { get set }

    func getModel(by id: Int) -> Saloon?
    func applyDB(by id: Int, completion: @escaping () -> ())
    func contains(by id: Int) -> Bool
    func fetchData()
    func sortModel(filterID: Int)
    func updateDict() -> [IndexPath: Bool]
    func sortedSalonsByUserLocation() -> [Saloon]
}

protocol MainViewInput: AnyObject {
    func hideTabBar()
    func changeFavouritesAppearence(indexPath: IndexPath)
    func isActivityIndicatorShouldRotate(_ isRotate: Bool)
    func updateUIConection(isConnected: Bool)
    func reloadData()
    func showEmptyLabel(isShow: Bool)
}

final class MainPresenter: MainPresenterOutput {

    // MARK: - Properties

    weak var view: MainViewInput?

    var selectedFilters: [IndexPath: Bool] = [:]
    
    var sortedSaloons: [Saloon] = [] { // дата сорс коллекции
        didSet {
            view?.showEmptyLabel(isShow: sortedSaloons.isEmpty)
            view?.reloadData()
        }
    }

    var allSalons: [Saloon] = [] { // оставляем всегда нетронутым
        didSet {
            if sortedSaloons.isEmpty {
                sortedSaloons = allSalons
            }
        }
    }

    var isFirstLaunch = true

    var state: SearchState = .all {
        didSet {
            sortedSaloons = state == .near ? sortedSalonsByUserLocation() : allSalons
        }
    }

    private var cancellables = Set<AnyCancellable>()

    private var userCoordinates: CLLocationCoordinate2D?

    private let provider: SaloonProvider

    private let locationManager = DeviceLocationService.shared

    // MARK: - Initializer
    
    init(view: MainViewInput, provider: SaloonProvider) {
        self.view = view
        self.provider = provider

        self.fetchData()
        self.subscribeNotifications()
        self.locationManager.requestLocationUpdates()
        self.bind()
    }

    // MARK: - Instance methods

    @objc
    private func hideTabBarNotificationAction() {
        view?.hideTabBar()
    }

    @objc
    private func isInFavouriteNotificationAction(_ notification: Notification) {
        guard let userId = notification.userInfo?["userId"] as? Int else { return }

        view?.changeFavouritesAppearence(indexPath: (getSearchIndex(id: userId) ?? [0, 0]))
    }

    @objc
    private func connectivityStatus(_ notification: Notification) {
        if let isConnected = notification.userInfo?[Config.connectivityStatus] as? Bool {
            self.view?.updateUIConection(isConnected: isConnected)
        }
    }

    func updateDict() -> [IndexPath: Bool] {
        var resultDict: [IndexPath: Bool] = [:]
        for (index, value) in selectedFilters {
            let newIndex = IndexPath(item: index.item - 1, section: index.section + 1)
            resultDict[newIndex] = value
        }
        resultDict[IndexPath(item: 0, section: 0)] = state == .all ? false : true

        return resultDict
    }
}

extension MainPresenter {
    
    // MARK: - Instance methods

    func sortModel(filterID: Int) {
        if state == .all {
            sortedSaloons = allSalons.filter({ $0.saloonCodable.business_type_id == filterID })
        } else {
            sortedSaloons = sortedSalonsByUserLocation().filter({ $0.saloonCodable.business_type_id == filterID })
        }
    }

    func fetchData() {
        provider.fetchData { [weak self] saloons in
            self?.allSalons = saloons
        }
    }

    func getModel(by id: Int) -> Saloon? {
        return allSalons.first(where: { $0.saloonCodable.id == id })
    }

    func applyDB(by id: Int, completion: @escaping () -> ()) {
        let storageManager = FavouritesSalonsManager.shared

        if storageManager.contains(modelID: id) {
            storageManager.delete(modelID: id)
        } else {
            storageManager.add(modelID: id)
        }
        VibrationManager.shared.vibrate(for: .success)
        completion()
    }

    func contains(by id: Int) -> Bool {
        return !FavouritesSalonsManager.shared.contains(modelID: id)
    }

    // MARK: - Private

    private func getSearchIndex(id: Int) -> IndexPath? {
        if let index = sortedSaloons.firstIndex(where: { $0.saloonCodable.id == id }) {
            return [1, index]
        }
        return nil
    }

    private func subscribeNotifications() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(isInFavouriteNotificationAction(_ :)),
            name: .isInFavourite,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(hideTabBarNotificationAction),
            name: .showTabBar,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(connectivityStatus(_:)),
            name: .connecivityChanged, object: nil
        )
    }

    func sortedSalonsByUserLocation() -> [Saloon] {
        guard let userCoordinates else { return [] }

        let currentUserLocation = CLLocation(
            latitude: userCoordinates.latitude,
            longitude: userCoordinates.longitude
        )

        let nearSalons = allSalons.map { saloon in
            let saloonDistance = CLLocation(
                latitude: saloon.saloonCodable.coordinate_lat,
                longitude: saloon.saloonCodable.coordinate_lon
            )

            return SaloonModel(
                saloonCodable: saloon.saloonCodable,
                distance: currentUserLocation.distance(from: saloonDistance)
            )
        }.filter { ($0.distance ?? 0.0) <= 12000 }

        return nearSalons
    }

    private func bind() {
        locationManager.currentLocation
            .sink(receiveCompletion: { _ in
            debugPrint("Failure to update user location")
        }) { [weak self] userCoordinates in
            self?.userCoordinates = userCoordinates
        }.store(in: &cancellables)

        locationManager.deniedLocationAccess
            .receive(on: DispatchQueue.main)
            .sink { _ in
                debugPrint("Denied location updates by user")
            }.store(in: &cancellables)
    }
}
