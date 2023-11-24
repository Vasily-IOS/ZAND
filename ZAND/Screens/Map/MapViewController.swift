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

        presenter?.isZoomed = true
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
        let settingsAction = UIAlertAction(title: AssetString.yes.rawValue, style: .default) { alert in
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

    func updateScale(isZoomed: Bool, userCoordinates: CLLocationCoordinate2D) {
        contentView.configure(isZoomed: isZoomed, userCoordinates: userCoordinates)
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
                presenter?.sortedSalons ?? [],
                allModel: presenter?.immutableSalons ?? [],
                isNear: presenter?.isZoomed
            )
        ) { [weak self] model in
            guard let self else { return }

            self.contentView.showSinglePin(
                coordinate_lat: model.saloonCodable.coordinate_lat,
                coordinate_lon: model.saloonCodable.coordinate_lon
            )
        } segmentHandler: { [weak self] isNear in
            self?.presenter?.isZoomed = isNear
        }
    }

    func showDetail(by id: Int) {
        if let model = presenter?.getSaloonModel(by: id) {
            AppRouter.shared.push(.saloonDetail(model))
        }
    }

    func changeScale() {
        presenter?.isZoomed?.toggle()
    }

    func showUser() {
        presenter?.showUser()
    }
}

extension MapViewController: HideNavigationBar {}
