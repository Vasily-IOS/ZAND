//
//  ServicesViewModel.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import Foundation

protocol ServicesPresenterOutput: AnyObject {
    var model: [Categories] { get set }
    var saloonID: Int { get }
    var viewModel: ConfirmationViewModel { get set }
    func search(text: String)
    func setServiceID(serviceID: Int)
}

protocol ServicesViewInput: AnyObject {
    func reloadData()
}

final class ServicesPresenter: ServicesPresenterOutput {

    // MARK: - Properties

    weak var view: ServicesViewInput?

    var model: [Categories] = []

    var adittionalModel: [Categories] = []

    let saloonID: Int

    var viewModel: ConfirmationViewModel

    private let network: HTTP

    // MARK: - Initializers

    init(view: ServicesViewInput,
         saloonID: Int,
         network: HTTP,
         viewModel: ConfirmationViewModel
    ) {
        self.view = view
        self.saloonID = saloonID
        self.network = network
        self.viewModel = viewModel

        self.fetchData()
    }

    // MARK: - Instance methods

    func search(text: String) {
        let sortedModel = adittionalModel.filter { model in
            model.category.title.uppercased().contains(text.uppercased())
        }
        model = text.isEmpty ? adittionalModel : sortedModel
        view?.reloadData()
    }

    func setServiceID(serviceID: Int) {
        viewModel.serviceID = serviceID
    }

    private func fetchData() {
        let group = DispatchGroup()
        var result: [Categories] = []

        group.enter()
        fetchCategoriesAndServices { (categories, services) in
            self.createResultModel(categories: categories, services: services) { resultModel in
                result = resultModel
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.model = result
            self.adittionalModel = result
            self.view?.reloadData()
        }
    }

    private func fetchCategories(completion: @escaping (([CategoryJSON]) -> Void)) {
        network.performRequest(
            type: .categories(saloonID),
            expectation: CategoriesJSON.self)
        { categories in
            completion(categories.data)
        }
    }

    private func fetchBookServices(completion: @escaping (([BookService]) -> Void)) {
        network.performRequest(
            type: .bookServices(company_id: saloonID),
            expectation: BookServicesModel.self) { bookServices in
                completion(bookServices.data.services)
            }
    }

    private func fetchCategoriesAndServices(
        completion: @escaping ([CategoryJSON], [BookService]) -> Void) {
            let group = DispatchGroup()
            var categoriesToFetch: [CategoryJSON] = []
            var servicesToFetch: [BookService] = []

            group.enter()
            fetchCategories { categoriesJSON in
                categoriesToFetch = categoriesJSON
                group.leave()
            }

            group.enter()
            fetchBookServices() { services in
                servicesToFetch = services
                group.leave()
            }

            group.notify(queue: .main) {
                completion(categoriesToFetch, servicesToFetch)
            }
        }

    private func createResultModel(
        categories: [CategoryJSON],
        services: [BookService],
        completion: @escaping (([Categories]) -> Void)) {
            let group = DispatchGroup()
            var result: [Categories] = []

            group.enter()
            categories.forEach { category in
                let category = Categories(
                    category: category,
                    services: services.filter(
                        { $0.category_id == category.id && $0.active == 1 })
                )
                result.append(category)
            }
            group.leave()

            group.notify(queue: .main) {
                completion(result.filter({ !$0.services.isEmpty }))
            }
        }
}
