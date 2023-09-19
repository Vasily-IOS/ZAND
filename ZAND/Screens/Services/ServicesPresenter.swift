//
//  ServicesViewModel.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import Foundation

protocol ServicesPresenterOutput: AnyObject {
    var services: [Service] { get }
//    var filterServices: [Service] { get }
    func search(text: String)
    func fetchServices()
//    func getServices()
}

protocol ServicesViewInput: AnyObject {
    func updateUI(model: [Service])
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

        self.fetchServices()
    }

    // MARK: - Instance methods

    func search(text: String) {
        text.isEmpty ? view?.updateUI(model: services) :
        view?.updateUI(model: services.filter { model in
            model.title.uppercased().contains(text.uppercased())})
    }

    func fetchServices() {
        network.performRequest(
            type: .serviceCategory(saloonID),
            expectation: ServiceByCategoryModel.self)
        { [weak self] result in
            guard let self else { return }

            self.services = result.data
            self.view?.updateUI(model: result.data)
        }
    }
}
