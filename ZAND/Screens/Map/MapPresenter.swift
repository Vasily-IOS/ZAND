//
//  MapPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

protocol MapPresenterOutput: AnyObject {
    func updateUI()
//    func getModel() -> [SaloonMapModel]
    func getModel(by id: Int) -> SaloonMapModel?
}

protocol MapViewInput: AnyObject {
    func updateUI(model: [SaloonMapModel])
}

final class MapPresenter: MapPresenterOutput {

    // MARK: - Properties

    weak var view: MapViewInput?

    private let provider: SaloonProvider

    // MARK: - Initializers

    init(view: MapViewInput, provider: SaloonProvider) {
        self.view = view
        self.provider = provider
    }

    // MARK: - Instance methods

    func updateUI() {
        provider.fetchData { [weak self] saloons in
            self?.view?.updateUI(model: saloons)
        }
    }

//    func getModel() -> [SaloonMapModel] {
//        return model
//    }

    func getModel(by id: Int) -> SaloonMapModel? {
        var saloonMapModel: SaloonMapModel?

        provider.fetchData { saloons in
            if let model = saloons.first(where: { $0.id == id }) {
                saloonMapModel = model
            }
        }
        
        return saloonMapModel
    }
}
