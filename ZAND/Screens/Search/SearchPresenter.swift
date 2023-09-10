//
//  SearchPresenter.swift
//  ZAND
//
//  Created by Василий on 06.06.2023.
//

import Foundation

protocol SearchViewInput: AnyObject {
    func updateUI(with model: [Saloon])
}

protocol SearchPresenterOutput: AnyObject {
    func updateUI()
    func getModel() -> [Saloon]
    func search(text: String)
}

final class SearchPresenter: SearchPresenterOutput {

    // MARK: - Properties
    
    weak var view: SearchViewInput?

    var currentModel: [Saloon] = []

    private let model: [Saloon]

    // MARK: - Initializers
    
    init(view: SearchViewInput, model: [Saloon]) {
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
                model.title.uppercased().contains(text.uppercased())})

            view?.updateUI(with: filtedModel)
            currentModel = filtedModel
        }
    }

    func getModel() -> [Saloon] {
        return model
    }
}
