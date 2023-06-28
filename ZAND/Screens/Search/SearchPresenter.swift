//
//  SearchPresenter.swift
//  ZAND
//
//  Created by Василий on 06.06.2023.
//

import Foundation

protocol SearchViewProtocol: AnyObject {
    func updateUI(with model: [SaloonMockModel])
}

protocol SearchPresenterProtocol: AnyObject {
    func getData()
}

final class SearchPresenter: SearchPresenterProtocol {
    
    var model: [SaloonMockModel]?
    
    weak var view: SearchViewProtocol?
    
    init(view: SearchViewProtocol, model: [SaloonMockModel]) {
        self.view = view
        self.model = model
    }
}

extension SearchPresenter {
    
    // MARK: - SearchPresenter methods
    
    func getData() {
        if let model = model {
            view?.updateUI(with: model)
        }
    }
}
