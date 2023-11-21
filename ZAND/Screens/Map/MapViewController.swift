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
            title: "Геопозиция отключена",
            message: "Включить?",
            preferredStyle: .alert
        )
        let settingsAction = UIAlertAction(title: AssetString.yes, style: .default) { alert in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: AssetString.no, style: .cancel)
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

    func addPinsOnMap(from model: [SaloonMapModel]) {
        contentView.addPinsOnMap(model: model)
    }

    func updateUserLocation(isCanUpdate: Bool) {
        if isCanUpdate {
            contentView.showUserLocation()
        } else {
            showAlertLocation()
        }
    }
}

extension MapViewController: MapDelegate {

    // MARK: - MapDelegate methods

    func showSearch() {
        guard let isZoomed = presenter?.isZoomed,
              let distances = isZoomed ? presenter?.distances : [] else { return }

        AppRouter.shared.presentSearch(
            type: .search(presenter?.sortedSalons ?? [], distances)
        ) { [weak self] model in
            self?.contentView.showSinglePin(
                coordinate_lat: model.coordinate_lat,
                coordinate_lon: model.coordinate_lon
            )
        }
    }

    func showDetail(by id: Int) {
        if let model = presenter?.getSaloonModel(by: id) as? Saloon {
            AppRouter.shared.push(.saloonDetail(.api(model), presenter?.getDistance(by: id) ?? ""))
        }
    }

    func changeScale() {
        presenter?.isZoomed?.toggle()
    }
}

extension MapViewController: HideNavigationBar {}
