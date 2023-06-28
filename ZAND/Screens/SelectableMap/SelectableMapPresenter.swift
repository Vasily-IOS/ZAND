//
//  SelectablePresenter.swift
//  ZAND
//
//  Created by Василий on 22.05.2023.
//

import Foundation

// input - делает что-то с UI
protocol SelectablePresenter: AnyObject {
    func updateUI(model: CommonModel)
}

// output - presenter сделай что-то
protocol SelectablePresenterImpl: AnyObject {
    func getModel()
}

final class SelectableMapPresenter: SelectablePresenterImpl {

    // MARK: - Properties

    weak var view: SelectablePresenter?

    var model: CommonModel

    // MARK: - Initializers

    init(view: SelectablePresenter, model: CommonModel) {
        self.view = view
        self.model = model
    }

    // MARK: - Instance methods

    func getModel() {
        view?.updateUI(model: model)
    }
}
