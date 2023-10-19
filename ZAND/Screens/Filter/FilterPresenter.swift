//
//  FilterPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import UIKit

enum FilterType {
    case options
}

protocol FilterPresenterOutput: AnyObject {
    var selectFilters: [IndexPath: Bool] { get set }
    var selectFiltersToTransfer: [IndexPath: Bool] { get }
    func getModel(by type: FilterType) -> [CommonFilterProtocol]
}

protocol FilterViewInput: AnyObject {
    func filterAlreadyContains(contains: Bool)
}

final class FilterPresenter: FilterPresenterOutput {

    // MARK: - Properties

    weak var view: FilterViewInput?

    var selectFilters: [IndexPath: Bool] = [:] {
        didSet {
            configureModelToTransfer(selectDict: selectFilters)
        }
    }

    var selectFiltersToTransfer: [IndexPath: Bool] = [:] {
        didSet {
            view?.filterAlreadyContains(contains: selectFiltersToTransfer.isEmpty)
        }
    }

    // MARK: -  Initializers

    init(view: FilterViewInput, selectFilters: [IndexPath: Bool]) {
        self.view = view

        configureModel(selectDict: selectFilters)
    }

    // MARK: - Instance methods

    func getModel(by type: FilterType) -> [CommonFilterProtocol] {
        switch type {
        case .options:
            return OptionsModel.optionsWithoutFilter()
        }
    }

    private func configureModel(selectDict: [IndexPath: Bool]) {
        var newIndexes: [IndexPath: Bool] = [:]
        for (index, value) in selectDict {
            let newIndex: IndexPath = [0, index.item - 1]
            newIndexes[newIndex] = value
        }
        self.selectFilters = newIndexes
        view?.filterAlreadyContains(contains: newIndexes.isEmpty)
    }

    private func configureModelToTransfer(selectDict: [IndexPath: Bool]) {
        var indexesToTransfer: [IndexPath: Bool] = [:]
        for (index, value) in selectDict {
            let newIndex: IndexPath = [0, index.item + 1]
            indexesToTransfer[newIndex] = value
        }
        self.selectFiltersToTransfer = indexesToTransfer.filter({ $0.value == true })
    }
}
