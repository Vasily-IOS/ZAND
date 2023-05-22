//
//  SelectablePresenter.swift
//  ZAND
//
//  Created by Василий on 22.05.2023.
//

import Foundation

protocol SelectableViewProtocol: AnyObject {}

protocol SelectablePresenterProtocol: AnyObject {}

final class SelectableMapPresenter: SelectablePresenterProtocol {
    
    weak var view: SelectableViewProtocol?
    
    init(view: SelectableViewProtocol) {
        self.view = view
    }
}
