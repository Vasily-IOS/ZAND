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
        }
    }
}
