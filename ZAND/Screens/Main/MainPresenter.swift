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
    var immutableSalons: [Saloon] { get }
    var selectedFilters: [IndexPath: Bool] { get set }
    var isFirstLaunch: Bool { get set }
    var nearSalons: [Saloon] { get set }
    var state: SearchState { get set }

    func getModel(by id: Int) -> Saloon?
    func applyDB(by id: Int, completion: @escaping () -> ())
    func contains(by id: Int) -> Bool
    func fetchData()
    func backToInitialState()
    func sortModel(filterID: Int)
    func updateDict() -> [IndexPath: Bool]
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

    var selectedFilters: [IndexPath: Bool] = [:] {
        didSet {
            print(selectedFilters)
        }
    }

    var sortedSaloons: [Saloon] = [] { // дата сорс коллекции
        didSet {
            view?.showEmptyLabel(isShow: sortedSaloons.isEmpty)
            view?.reloadData()
        }
    }

    var immutableSalons: [Saloon] = []  // оставляем всегда нетронутым

    var nearSalons: [Saloon] = []

    var isFirstLaunch = true

    var state: SearchState = .all {
        didSet {
            sortedSaloons = state == .near ? nearSalons : immutableSalons
        }
    }

    private var cancellables = Set<AnyCancellable>()

    private let provider: SaloonProvider

    private let locationManager = DeviceLocationService.shared

    // MARK: - Initializer
    
    init(view: MainViewInput, provider: SaloonProvider) {
        self.view = view
        self.provider = provider

        self.locationManager.requestLocationUpdates()
        self.bind()
        self.subscribeNotifications()
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

    func backToInitialState() {
        sortedSaloons = immutableSalons
    }

    func sortModel(filterID: Int) {
        sortedSaloons = immutableSalons.filter({ $0.saloonCodable.business_type_id == filterID })
    }

    func fetchData() {
        provider.fetchData { [weak self] saloons in
            self?.sortedSaloons = saloons
            self?.immutableSalons = saloons
            self?.view?.reloadData()
        }
    }

    func getModel(by id: Int) -> Saloon? {
        return sortedSaloons.first(where: { $0.saloonCodable.id == id })
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

    func calculateNearSaloons(coordinates: CLLocationCoordinate2D) {
        let currentUserLocation = CLLocation(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude
        )

        let nearSalons = immutableSalons.map { saloon in
            let saloonDistance = CLLocation(
                latitude: saloon.saloonCodable.coordinate_lat,
                longitude: saloon.saloonCodable.coordinate_lon
            )

            return SaloonModel(
                saloonCodable: saloon.saloonCodable,
                distance: currentUserLocation.distance(from: saloonDistance)
            )
        }.filter { ($0.distance ?? 0.0) <= 12000 }

        self.nearSalons = nearSalons
    }

    private func bind() {
        locationManager.currentLocation.sink(receiveCompletion: { _ in
            debugPrint("Failure to update user location")
        }) { [weak self] userCoordinates in
            self?.calculateNearSaloons(coordinates: userCoordinates)
        }.store(in: &cancellables)
    }
}
