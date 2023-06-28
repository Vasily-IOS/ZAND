//
//  SettingsPresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

protocol SettingsPresenterOutput: AnyObject {
    func getData()
    func reloadData()
}

protocol SettingsInput: AnyObject {
    func updateUI(model: [SettingsMenuModel])
    func reloadData()
}

final class SettingsPresenterImpl: SettingsPresenterOutput {

    // MARK: - Properties

    weak var view: SettingsInput?

    private let model = SettingsMenuModel.model

    // MARK: - Initializers

    init(view: SettingsInput) {
        self.view = view
    }

    func getData() {
        view?.updateUI(model: model)
    }

    func reloadData() {
        self.view?.reloadData()
    }
}
