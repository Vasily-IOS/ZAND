//
//  MainPresenter.swift
//  ZAND
//
//  Created by Василий on 07.06.2023.
//

import Foundation

protocol MainPresenterProtocol: AnyObject {
    func getOptionsModel()
    func getSaloonMockModel()
    func getSearchIndex(id: Int) -> IndexPath?
}

protocol MainViewProtocol: AnyObject {
    func updateWithOptions(model: [OptionsModel])
    func updateWithSaloonMock(model: [SaloonMockModel])
}

final class MainPresenter: MainPresenterProtocol {
    
    // MARK: - Properties
    
    private let optionsModel = OptionsModel.options
    private var saloonMockModel = SaloonMockModel.saloons
    
    // MARK: - UI
    
    weak var view: MainViewProtocol?
    
    // MARK: - Initializer
    
    init(view: MainViewProtocol) {
        self.view = view
    }
}

extension MainPresenter {
    
    // MARK: - Instance methods
    
    func getOptionsModel() {
        self.view?.updateWithOptions(model: optionsModel)
    }
    
    func getSaloonMockModel() {
        self.view?.updateWithSaloonMock(model: saloonMockModel)
    }
    
    func getSearchIndex(id: Int) -> IndexPath? {
        if let index = saloonMockModel.firstIndex(where: { $0.id == id }) {
            return [1, index]
        }
        return nil
    }
}
