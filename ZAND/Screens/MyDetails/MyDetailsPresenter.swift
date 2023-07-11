//
//  SettingsPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

protocol MyDetailsPresenterOutput: AnyObject {
    func getModel() -> [SettingsMenuModel]
}

protocol MyDetailsInput: AnyObject {}

final class MyDetailsPresenterImpl: MyDetailsPresenterOutput {

    // MARK: - Properties

    weak var view: MyDetailsInput?

    // MARK: - Initializers

    init(view: MyDetailsInput) {
        self.view = view
    }

    func getModel() -> [SettingsMenuModel] {
        return SettingsMenuModel.model
    }
}
