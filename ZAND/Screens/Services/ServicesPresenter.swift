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
    func search(text: String)
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

    private let network: HTTP

    // MARK: - Initializers

    init(view: ServicesViewInput, saloonID: Int, network: HTTP) {
        self.view = view
        self.saloonID = saloonID
        self.network = network

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

    private func fetchServices(completion: @escaping (([Service]) -> Void)) {
        network.performRequest(
            type: .services(company_id: saloonID, category_id: 0),
            expectation: Services.self) { result in
                // услуги, на которые можно записаться
                completion(result.data.filter({ !$0.staff.isEmpty }))
            }
    }

    private func fetchCategoriesAndServices(
        completion: @escaping ([CategoryJSON], [Service]) -> Void) {
            let group = DispatchGroup()
            var servicesToFetch: [Service] = []
            var categoriesToFetch: [CategoryJSON] = []

            group.enter()
            fetchCategories { categoriesJSON in
                categoriesToFetch = categoriesJSON
                group.leave()
            }

            group.enter()
            fetchServices { services in
                servicesToFetch = services
                group.leave()
            }

            group.notify(queue: .main) {
                completion(categoriesToFetch, servicesToFetch)
            }
        }

    private func createResultModel(
        categories: [CategoryJSON],
        services: [Service],
        completion: @escaping (([Categories]) -> Void)) {
            let group = DispatchGroup()
            var result: [Categories] = []

            group.enter()
            categories.forEach { category in
                let category = Categories(
                    category: category,
                    services: services.filter(
                        { $0.category_id == category.id })
                )
                result.append(category)
            }
            group.leave()

            group.notify(queue: .main) {
                completion(result.filter({ !$0.services.isEmpty }))
            }
        }
}
