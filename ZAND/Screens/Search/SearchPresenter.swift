//
//  SearchPresenter.swift
//  ZAND
//
//  Created by Василий on 06.06.2023.
//

import UIKit
import CoreLocation

protocol SearchViewInput: AnyObject {
    func updateUI(with model: [Saloon], and distances: [DistanceModel])
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

    var currentDistances: [DistanceModel] = []

    private let immutableSalons: [Saloon]

    private let immutableDistances: [DistanceModel]

    // MARK: - Initializers
    
    init(view: SearchViewInput, model: [Saloon], locations: [DistanceModel]) {
        self.view = view
        self.immutableSalons = model
        self.immutableDistances = locations

        print("Количество салонов \(model.count), кол-во локаций \(locations.count)")
    }
}

extension SearchPresenter {
    
    // MARK: - SearchPresenter methods
    
    func updateUI() {
        view?.updateUI(with: immutableSalons, and: immutableDistances)
        currentModel = immutableSalons
    }

    func search(text: String) {
        if text.isEmpty {
            view?.updateUI(with: immutableSalons, and: immutableDistances)
//            currentModel = immutableSalons
        } else {
            let group = DispatchGroup()
            var filteredDistances: [DistanceModel] = []

            group.enter()
            let filtedModel = immutableSalons.filter({ model in
                return model.title.uppercased().contains(text.uppercased())
            })
            group.leave()

            group.enter()
            filtedModel.forEach { model in
                if let model = immutableDistances.first(where: { $0.id == model.id }) {
                    filteredDistances.append(model)
                }
            }
            group.leave()

            group.notify(queue: .main) {
                self.view?.updateUI(with: filtedModel, and: filteredDistances)
            }
        }
    }

    func getModel() -> [Saloon] {
        return immutableSalons
    }
}
