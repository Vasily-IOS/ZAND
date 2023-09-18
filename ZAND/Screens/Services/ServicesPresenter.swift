//
//  ServicesViewModel.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import Foundation

protocol ServicesPresenterOutput: AnyObject {
    func showServices()
    var services: [Service] { get }
}

protocol ServicesViewInput: AnyObject {
    func reloadData()
}

final class ServicesPresenter: ServicesPresenterOutput {

    // MARK: - Properties

    weak var view: ServicesViewInput?

    var services: [Service] = []

    private let network: HTTP

    private let saloonID: Int

    // MARK: - Initializers

    init(view: ServicesViewInput, saloonID: Int, network: HTTP) {
        self.view = view
        self.saloonID = saloonID
        self.network = network
    }

    // MARK: - Instance methods

    func showServices() {
        network.performRequest(
            type: .serviceCategory(saloonID),
            expectation: ServiceByCategoryModel.self)
        { [weak self] result in
            self?.services = result.data
            self?.view?.reloadData()
        }
    }
}
