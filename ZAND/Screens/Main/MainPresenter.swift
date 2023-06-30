//
//  MainPresenter.swift
//  ZAND
//
//  Created by Василий on 07.06.2023.
//

import Foundation

enum MainType {
    case options
    case saloons
}

protocol MainPresenterOutput: AnyObject {
//    func updateUI(by types: [MainType])
    func getModel(by type: MainType) -> [CommonFilterProtocol]
    func getSearchIndex(id: Int) -> IndexPath?
    func getModel(by id: Int) -> SaloonMockModel?
}

protocol MainViewInput: AnyObject {
//    func updateUI(with model: [CommonFilterProtocol])
}

final class MainPresenter: MainPresenterOutput {
    
    // MARK: - Properties
    
    private let optionsModel = OptionsModel.options
    private var saloonsModel = SaloonMockModel.saloons
    
    // MARK: - UI
    
    weak var view: MainViewInput?
    
    // MARK: - Initializer
    
    init(view: MainViewInput) {
        self.view = view
    }
}

extension MainPresenter {
    
    // MARK: - Instance methods

//    func updateUI(by types: [MainType]) {
//        for type in types {
//            view?.updateUI(with: getModel(by: type))
//        }
//    }

    func getSearchIndex(id: Int) -> IndexPath? {
        if let index = saloonsModel.firstIndex(where: { $0.id == id }) {
            return [1, index]
        }
        return nil
    }

    func getModel(by type: MainType) -> [CommonFilterProtocol] {
        switch type {
        case .options:
            return optionsModel
        case .saloons:
            return saloonsModel
        }
    }

    func getModel(by id: Int) -> SaloonMockModel? {
        return saloonsModel.first(where: { $0.id == id })
    }
}
