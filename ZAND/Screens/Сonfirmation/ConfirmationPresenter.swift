//
//  ConfirmationPresenter.swift
//  ZAND
//
//  Created by Василий on 28.09.2023.
//

import Foundation

protocol ConfirmationOutput: AnyObject {
    var viewModel: ConfirmationViewModel { get }
}

protocol ConfirmationInput: AnyObject {

}

final class ConfirmationPresenter: ConfirmationOutput {

    // MARK: - Properties

    weak var view: ConfirmationInput?

    var viewModel: ConfirmationViewModel 

    // MARK: - Initializers

    init(view: ConfirmationInput, viewModel: ConfirmationViewModel) {
        self.view = view
        self.viewModel = viewModel
    }

    // MARK: - Instance methods

}
