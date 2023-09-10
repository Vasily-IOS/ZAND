//
//  SecondViewController.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

final class MapViewController: BaseViewController<MapView> {
    
    // MARK: - Properties

    var presenter: MapPresenterOutput?
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
        presenter?.updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        hideNavigationBar()
    }
    
    deinit {
        print("MapViewController died")
    }

    // MARK: - Instance methods

    private func subscribeDelegate() {
        contentView.delegate = self
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
