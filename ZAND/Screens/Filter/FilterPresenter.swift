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
    func getModel(by type: FilterType) -> [CommonFilterProtocol]
}

protocol FilterViewInput: AnyObject {
    func filterAlreadyContains(contains: Bool)
}

final class FilterPresenter: FilterPresenterOutput {

    // MARK: - Properties

    var selectFilters: [IndexPath: Bool]

    weak var view: FilterViewInput?

    // MARK: -  Initializers

    init(view: FilterViewInput, selectFilters: [IndexPath: Bool]) {
        self.view = view

        var newIndexes: [IndexPath: Bool] = [:]
        for (index, value) in selectFilters {
            let newIndex: IndexPath = [0, index.item - 1]
            newIndexes[newIndex] = value
        }
        self.selectFilters = newIndexes
        view.filterAlreadyContains(contains: newIndexes.isEmpty)
    }

    // MARK: - Instance methods

    func getModel(by type: FilterType) -> [CommonFilterProtocol] {
        switch type {
        case .options:
            return OptionsModel.optionsWithoutFilter()
        }
    }
}
