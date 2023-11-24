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
    var isNear: Bool { get set }
    var modelUI: [Saloon] { get set }

    func updateUI(isNear: Bool)
    func getModel(id: Int) -> Saloon?
    func search(text: String)
    func updateSegment()
}

final class SearchPresenter: SearchPresenterOutput {

    // MARK: - Properties
    
    weak var view: SearchViewInput?

    var isNear: Bool {
        didSet {
            updateUI(isNear: isNear)
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
        isNear: Bool
    ) {
        self.view = view
        self.nearModel = sortedModel
        self.originalModel = allModel
        self.isNear = isNear

        print(nearModel.count)

        updateUI(isNear: isNear)
        updateSegment()
    }
}

extension SearchPresenter {
    
    // MARK: - SearchPresenter methods

    func updateUI(isNear: Bool) {
        if isNear {
            modelUI = nearModel
        } else {
            modelUI = originalModel
        }

        view?.updateUI(with: modelUI)
    }

    func search(text: String) {
        if text.isEmpty {
            updateUI(isNear: isNear)
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
        view?.updateSegment(index: isNear ? 0 : 1)
    }

    // MARK: - Private methods

    private func getActualModel() -> [Saloon] {
        return isNear ? nearModel : originalModel
    }
}
