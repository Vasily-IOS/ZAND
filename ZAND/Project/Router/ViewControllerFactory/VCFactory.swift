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
        case .search:
            let view = SearchView()
            let vc = SearchViewController(contentView: view)
            return vc
        case .main:
            let layotBuilder: LayoutBuilderProtocol = LayoutBuilder()
            let view = MainView(layoutBuilder: layotBuilder)
            let vc = MainViewController(contentView: view)
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
            let layoutBuilder: DefaultLayoutBuilder = FilterLayoutBuilder()
            let view = FilterView(layout: layoutBuilder)
            let vc = FilterViewController(contentView: view)
            return vc
        case .profile:
            let layout: DefaultProfileLayoutProtocol = ProfileLayoutBuilder()
            let view = ProfileView(layout: layout)
            let vc = ProfileViewController(contentView: view)
            return vc
        case .appointments:
//            let layout =
            let view = AppointemtsView()
            let vc = AppointmentsViewController(contentView: view)
            return vc
        case .settings:
//            let layout =
            let view = SettingsView()
            let vc = SettingsViewController(contentView: view)
            return vc
        }
    }
}
