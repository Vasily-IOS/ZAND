//
//  MapPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

protocol MapPresenterOutput: AnyObject {
    func updateUI()
    func getModel() -> [SaloonMockModel]
    func getModel(by id: Int) -> SaloonMockModel?
}

protocol MapViewInput: AnyObject {
    func updateUI(model: [SaloonMockModel])
}

final class MapPresenter: MapPresenterOutput {

    // MARK: - Properties

    weak var view: MapViewInput?

    private let model = SaloonMockModel.saloons

    // MARK: - Initializers

    init(view: MapViewInput) {
        self.view = view
    }

    // MARK: - Instance methods

    func updateUI() {
        view?.updateUI(model: model)
    }

    func getModel() -> [SaloonMockModel] {
        return model
    }

    func getModel(by id: Int) -> SaloonMockModel? {
        guard let model = model.first(where: { $0.id == id }) else { return nil }

        return model
    }
}
