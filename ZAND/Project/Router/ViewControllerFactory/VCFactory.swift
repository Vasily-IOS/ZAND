//
//  VCFactory.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

final class VCFactory: DefaultVCFactory {
    func getViewController(for type: VCType) -> UIViewController {
        switch type {
        case .tabBar:
            let vc = TabBarController()
            return vc
        case .search(let model):
            let view = SearchView()
            let vc = SearchViewController(contentView: view)
            let presenter = SearchPresenter(view: vc, model: model)
            vc.presenter = presenter
            return vc
        case .main:
            let layotBuilder: DefaultMainLayout = MainLayout()
            let view = MainView(layoutBuilder: layotBuilder)
            let vc = MainViewController(contentView: view)
            let presenter = MainPresenter(view: vc)
            vc.presenter = presenter
            return vc
        case .map:
            let model = SaloonMockModel.saloons // !
            let view = MapView(model: model)
            let vc = MapViewController(contentView: view)
            return vc
        case .saloonDetail(let model):
            let view = SaloonDetailView(model: model)
            let vc = SaloonDetailViewController(contentView: view)
            return vc
        case .register:
            let view = RegisterView()
            let vc = RegisterViewController(contentView: view)
            return vc
        case .filter:
            let layoutBuilder: DefaultFilterLayout = FilterLayout()
            let view = FilterView(layout: layoutBuilder)
            let vc = FilterViewController(contentView: view)
            return vc
        case .profile:
            let layout: DefaultProfileLayout = ProfileLayoutBuilder()
            let view = ProfileView(layout: layout)
            let vc = ProfileViewController(contentView: view)
            return vc
        case .appointments:
            let view = AppointemtsView()
            let vc = AppointmentsViewController(contentView: view)
            let presenter = AppointmentsPresenterImpl(view: vc)
            vc.presenter = presenter
            return vc

        case .settings:
            let layout: DefaultSettingsLayout = SettingsLayout()
            let view = SettingsView(layout: layout)
            let vc = SettingsViewController(contentView: view)
            let presenter = SettingsPresenterImpl(view: vc)
            vc.presenter = presenter
            return vc
        case .booking:
            return BookingViewController()
        case .selectableMap(let model):
            let view = SelectableMapView()
            let vc = SelectableViewController(contentView: view)
            let presenter = SelectableMapPresenter(view: vc, model: model)
            vc.presenter = presenter
            return vc
        }
    }
}
