//
//  ServicesViewModel.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import Foundation

protocol ServicesPresenterOutput: AnyObject {
    var model: [Categories] { get set }
    var viewModel: ConfirmationViewModel { get set }
    func search(text: String)
}

protocol ServicesViewInput: AnyObject {
    func reloadData()
    func showIndicator(_ isShow: Bool)
}

final class ServicesPresenter: ServicesPresenterOutput {

    // MARK: - Properties

    weak var view: ServicesViewInput?

    var model: [Categories] = []

    var adittionalModel: [Categories] = []

    var viewModel: ConfirmationViewModel

    private let network: APIManager

    // MARK: - Initializers

    init(view: ServicesViewInput,
         network: APIManager,
         viewModel: ConfirmationViewModel
    ) {
        self.view = view
        self.network = network
        self.viewModel = viewModel

        switch viewModel.bookingType {
        case .service:
            self.fetchData()
        case .staff:
            self.fetchData(staff_id: viewModel.staffID)
        case .default:
            break
        }
    }

    deinit {
        print("ServicesPresenter died")
    }

    // MARK: - Instance methods

    func search(text: String) {
        let sortedModel = adittionalModel.filter { model in
            model.category.title.uppercased().contains(text.uppercased())
        }
        model = text.isEmpty ? adittionalModel : sortedModel
        view?.reloadData()
    }

    private func fetchData(staff_id: Int = 0) {
        let group = DispatchGroup()
        var result: [Categories] = []

        view?.showIndicator(true)
        group.enter()
        fetchCategoriesAndServices(staff_id: staff_id) { (categories, services) in
            self.createResultModel(
                categories: categories,
                services: services)
            { resultModel in
                result = resultModel
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.model = result
            self.adittionalModel = result
            self.view?.showIndicator(false)
            self.view?.reloadData()
        }
    }

    private func fetchCategories(completion: @escaping (([CategoryJSON]) -> Void)) {
        network.performRequest(
            type: .categories(viewModel.company_id),
            expectation: CategoriesJSON.self)
        { categories in
            completion(categories.data)
        }
    }

    private func fetchBookServices(
        staff_id: Int,
        completion: @escaping (([BookService]) -> Void)
    ) {
        network.performRequest(
            type: .bookServices(company_id: viewModel.company_id, staff_id: staff_id),
            expectation: BookServicesModel.self) { bookServices in
                completion(bookServices.data.services)
            }
    }

    private func fetchCategoriesAndServices(
        staff_id: Int = 0,
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
            fetchBookServices(staff_id: staff_id) { services in
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
