//
//  RefreshPasswordPresenter.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

import Foundation

protocol RefreshPasswordInput: AnyObject {
    
}

protocol RefreshPasswordOutput: AnyObject {
    var view: RefreshPasswordInput { get }
}

final class RefreshPasswordPresenter: RefreshPasswordOutput {

    // MARK: - Properties

    unowned let view: RefreshPasswordInput

    // MARK: - Initializers

    init(view: RefreshPasswordInput) {
        self.view = view
    }
}
