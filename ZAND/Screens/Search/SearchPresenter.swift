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
    var mapState: MapState { get set }
    var modelUI: [Saloon] { get set }

    func updateUI(state: MapState)
    func getModel(id: Int) -> Saloon?
    func search(text: String)
    func updateSegment()
}

final class SearchPresenter: SearchPresenterOutput {

    // MARK: - Properties
    
    weak var view: SearchViewInput?

    var mapState: MapState {
        didSet {
            updateUI(state: mapState)
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
        state: MapState
    ) {
        self.view = view
        self.nearModel = sortedModel
        self.originalModel = allModel
        self.mapState = state

        updateUI(state: state)
        updateSegment()
    }
}

extension SearchPresenter {
    
    // MARK: - SearchPresenter methods

    func updateUI(state: MapState) {
        switch state {
        case .zoomed:
            modelUI = nearModel
        case .noZoomed:
            modelUI = originalModel
        default:
            break
        }

        view?.updateUI(with: modelUI)
    }

    func search(text: String) {
        if text.isEmpty {
            updateUI(state: .noZoomed)
        } else {
            let filtedModel = getActualModel().filter({ model in
                return model.saloonCodable.title.uppercased().contains(text.uppercased())
            })
            self.view?.updateUI(with: filtedModel)
            modelUI = filtedModel
        }
    }

    func getModel(id: Int) -> Saloon? {
        if let model = originalModel.first(where: { $0.saloonCodable.id == id }) {
            return model
        } else {
            return nil
        }
    }

    func updateSegment() {
        switch mapState {
        case .noZoomed:
            view?.updateSegment(index: 1)
        case .zoomed:
            view?.updateSegment(index: 0)
        default:
            break
        }
    }

    // MARK: - Private methods

    private func getActualModel() -> [Saloon] {
        switch mapState {
        case .zoomed:
            return nearModel
        case .noZoomed:
            return originalModel
        default:
            return []
        }
    }
}
