//
//  SecondViewController.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import CoreLocation
import Combine

final class MapViewController: BaseViewController<MapRectView> {
    
    // MARK: - Properties

    var presenter: MapPresenterOutput?
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        
        presenter?.mapState = .near
        presenter?.showUser()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideNavigationBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DeviceLocationService.shared.requestLocationUpdates()
    }
    
    deinit {
        print("MapViewController died")
    }

    // MARK: - Instance methods

    private func subscribeDelegate() {
        contentView.delegate = self
    }

    private func showAlertLocation() {
        let alertController = UIAlertController(
            title: AssetString.geoIsOff.rawValue,
            message: AssetString.willOn.rawValue,
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(
            title: AssetString.yes.rawValue,
            style: .default
        ) { alert in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: AssetString.no.rawValue, style: .cancel)
        alertController.addAction(settingsAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}

extension MapViewController: MapViewInput {

    // MARK: - MapViewInput methods

    func updateScale(state: SearchState, isShouldZoom: Bool?, coordinates: CLLocationCoordinate2D?) {
        switch state {
        case .near, .all:
            guard let isShouldZoom, let coordinates else { return }

            contentView.configure(state: .performZoom(coordinates), isShouldZoom: isShouldZoom)
        case let .saloonZoom(index, latitude, longtitude):
            let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
            let isShouldSelectNear: Bool = index == 0 ? true : false

            contentView.configure(state: .showSingle(coordinates), isShouldZoom: isShouldSelectNear)
        default:
            break
        }
    }

    func addPinsOnMap(from model: [Saloon]) {
        contentView.addPinsOnMap(model: model)
    }

    func updateUserLocation(isCanUpdate: Bool) {
        isCanUpdate ? contentView.confirmShowUserLocation() : showAlertLocation()
    }

    func showUser(coordinate: CLLocationCoordinate2D, willZoomToRegion: Bool) {
        contentView.showUserLocation(coordinate, willZoomToRegion: willZoomToRegion)
    }
}

extension MapViewController: MapDelegate {

    // MARK: - MapDelegate methods

    func showSearch() {
        AppRouter.shared.presentSearch(
            type: .search(
                presenter?.sortedSalonsByUserLocation() ?? [],
                allModel: presenter?.allSalons ?? [],
                state: presenter?.mapState
            )) { [weak self] state, _ in
                self?.presenter?.mapState = state
            }
    }

    func showDetail(by id: Int) {
        if let model = presenter?.getSaloonModel(by: id) {
            AppRouter.shared.push(.saloonDetail(model))
        }
    }

    func changeScale() {
        presenter?.mapState = presenter?.mapState == .near ? .all : .near
    }

    func showUser() {
        presenter?.showUser()
    }
}

extension MapViewController: HideNavigationBar {}
