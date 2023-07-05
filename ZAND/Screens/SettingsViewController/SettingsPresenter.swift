//
//  SettingsPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

protocol SettingsPresenterOutput: AnyObject {
    func getModel() -> [SettingsMenuModel]
}

protocol SettingsInput: AnyObject {}

final class SettingsPresenterImpl: SettingsPresenterOutput {

    // MARK: - Properties

    weak var view: SettingsInput?

    // MARK: - Initializers

    init(view: SettingsInput) {
        self.view = view
    }

    func getModel() -> [SettingsMenuModel] {
        return SettingsMenuModel.model
    }
}
