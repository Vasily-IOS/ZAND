//
//  SearchPresenter.swift
//  ZAND
//
//  Created by Василий on 06.06.2023.
//

import Foundation

protocol SearchViewInput: AnyObject {
    func updateUI(with model: [SaloonMockModel])
}

protocol SearchPresenterOutput: AnyObject {
    func updateUI()
    func getModel() -> [SaloonMockModel]
    func search(text: String)
}

final class SearchPresenter: SearchPresenterOutput {

    // MARK: - Properties
    
    weak var view: SearchViewInput?

    var currentModel: [SaloonMockModel] = []

    private let model: [SaloonMockModel]

    // MARK: - Initializers
    
    init(view: SearchViewInput, model: [SaloonMockModel]) {
        self.view = view
        self.model = model
    }
}

extension SearchPresenter {
    
    // MARK: - SearchPresenter methods
    
    func updateUI() {
        view?.updateUI(with: model)
        currentModel = model
    }

    func search(text: String) {
        if text.isEmpty {
            view?.updateUI(with: model)
            currentModel = model
        } else {
            let filtedModel = model.filter({ model in
                model.saloon_name.uppercased().contains(text.uppercased())})

            view?.updateUI(with: filtedModel)
            currentModel = filtedModel
        }
    }

    func getModel() -> [SaloonMockModel] {
        return model
    }
}
