//
//  SecondViewController.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit
import CoreLocation

final class MapViewController: BaseViewController<MapView> {
    
    // MARK: - Properties

    var presenter: MapPresenterOutput?
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }

    private lazy var locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()

    // MARK: - Lifecycle

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

        checkLocationServices()
    }
    
    deinit {
        print("MapViewController died")
    }

    // MARK: - Instance methods

    private func subscribeDelegate() {
        contentView.delegate = self
    }

    private func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            checkLocationAuthorization()
        } else {
            showAlertLocation()
        }
    }

    private func checkLocationAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            showAlertLocation()
            break
        case .authorizedWhenInUse:
            contentView.showUserLocation()
            // start update location
            break
        default:
            break
        }
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

extension MapViewController: CLLocationManagerDelegate {

    // MARK: - CLLocationManagerDelegate methods

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

extension MapViewController: MapViewInput {

    // MARK: - MapViewInput methods

    func updateUI(model: [SaloonMapModel]) {
        contentView.addPinsOnMap(model: model)
    }
}

extension MapViewController: MapDelegate {

    // MARK: - MapDelegate methods

    func showSearch() {
        if let model = presenter?.getModel() as? [Saloon] {
            AppRouter.shared.presentSearch(type: .search(model)) { [weak self] model in
                self?.contentView.showSinglePin(
                    coordinate_lat: model.coordinate_lat,
                    coordinate_lon: model.coordinate_lon
                )
            }
        }
    }

    func showDetail(by id: Int) {
        if let model = presenter?.getModel(by: id) as? Saloon {
            AppRouter.shared.push(.saloonDetail(.api(model)))
        }
    }
}

extension MapViewController: HideNavigationBar {}
