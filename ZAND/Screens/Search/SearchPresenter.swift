//
//  SearchPresenter.swift
//  ZAND
//
//  Created by Василий on 06.06.2023.
//

import UIKit
import CoreLocation

protocol SearchViewInput: AnyObject {
    func updateUI(with model: [Saloon])
    func updateSegment(index: Int)
}

protocol SearchPresenterOutput: AnyObject {
    var searchState: SearchState { get set }
    var modelUI: [Saloon] { get set }

    func updateUI(state: SearchState)
    func getModel(id: Int) -> Saloon?
    func search(text: String)
    func updateSegment()
}

final class SearchPresenter: SearchPresenterOutput {

    // MARK: - Properties
    
    unowned let view: SearchViewInput

    var searchState: SearchState = .none {
        didSet {
            updateUI(state: searchState)
        }
    }

    var modelUI: [Saloon] = [] // салоны, которые идут в коллекцию

    private let nearModel: [Saloon] // салоны, которые рядом

    private let originalModel: [Saloon] // все салоны

    // MARK: - Initializers
    
    init(
        view: SearchViewInput,
        sortedModel: [Saloon],
        allModel: [Saloon],
        state: SearchState
    ) {
        self.view = view
        self.nearModel = sortedModel
        self.originalModel = allModel
        self.searchState = state

        self.updateUI(state: state)
        self.updateSegment()
    }
}

extension SearchPresenter {
    
    // MARK: - SearchPresenter methods

    func updateUI(state: SearchState) {
        modelUI = state == .near ? nearModel : originalModel
        view.updateUI(with: modelUI)
    }

    func search(text: String) {
        if text.isEmpty {
            updateUI(state: .all)
        } else {
            let filtedModel = getActualModel().filter({ model in
                return model.saloonCodable.title.uppercased().contains(text.uppercased())
            })
            self.view.updateUI(with: filtedModel)
            modelUI = filtedModel
        }
    }

    func getModel(id: Int) -> Saloon? {
        let model = searchState == .near ? nearModel : originalModel
        if let saloonModel = model.first(where: { $0.saloonCodable.id == id }) {
            return saloonModel
        } else {
            return nil
        }
    }

    func updateSegment() {
        view.updateSegment(index: searchState == .near ? 0 : 1)
    }

    // MARK: - Private methods

    private func getActualModel() -> [Saloon] {
        return searchState == .near ? nearModel : originalModel
    }
}
