//
//  SaloonDetailPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

protocol SaloonPresenterOutput: AnyObject {
    func updateUI()
    func getModel() -> SaloonMockModel
}

protocol SaloonViewInput: AnyObject {
    func updateUI(model: SaloonMockModel)
}

final class SaloonDetailPresenter: SaloonPresenterOutput {

    // MARK: - Properties

    weak var view: SaloonViewInput?

    let model: SaloonMockModel

    // MARK: - Initializers

    init(view: SaloonViewInput, model: SaloonMockModel) {
        self.view = view
        self.model = model
    }

    // MARK: - Instance methods

    func updateUI() {
        view?.updateUI(model: model)
    }

    func getModel() -> SaloonMockModel {
        return model
    }
}
