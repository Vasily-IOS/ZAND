//
//  FilterPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import UIKit

enum FilterType {
    case filter
    case options
}

protocol FilterPresenterOutput: AnyObject {
    func getModel(by type: FilterType) -> [CommonFilterProtocol]
}

protocol FilterViewInput: AnyObject {}

final class FilterPresenter: FilterPresenterOutput {

    // MARK: - Properties

    weak var view: FilterViewInput?

    // MARK: -  Initializers

    init(view: FilterViewInput) {
        self.view = view
    }

    // MARK: - Instance methods

    func getModel(by type: FilterType) -> [CommonFilterProtocol] {
        switch type {
        case .filter:
            return FilterModel.filterModel
        case .options:
            return OptionsModel.optionWithoutFilterModel
        }
    }
}
