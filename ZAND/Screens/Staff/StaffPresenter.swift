//
//  StaffPresenter.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import Foundation

protocol StaffPresenterOutput: AnyObject {
    var viewModel: ConfirmationViewModel { get set }
    var fetchedStaff: [EmployeeCommon] { get }

    func fetchStaff()
}

protocol StaffViewInput: AnyObject {
    func reloadData()
    func showIndicator(_ isShow: Bool)
}

final class StaffPresenter: StaffPresenterOutput {

    // MARK: - Properties

    weak var view: StaffViewInput?

    var fetchedStaff: [EmployeeCommon] = []

    var viewModel: ConfirmationViewModel

    private let network: YclientsAPI

    // MARK: - Initializers

    init(
        view: StaffViewInput,
        network: YclientsAPI,
        serviceToProvideID: Int=0,
        viewModel: ConfirmationViewModel
    ) {
        self.view = view
        self.network = network
        self.viewModel = viewModel

        switch viewModel.bookingType {
        case .service:
            self.fetchBookStaff(company_id: viewModel.company_id, serviceID: viewModel.bookService?.id ?? 0)
        case .staff:
            self.fetchStaff()
        case .default:
            break
        }
    }

    deinit {
        print("StaffPresenter died")
    }

    // MARK: - Instance methods

    func fetchStaff() {
        view?.showIndicator(true)
        network.performRequest(
            type: .bookStaff(
                company_id: viewModel.company_id,
                service_id: []),
            expectation: EmployeeModel.self)
        { [weak self] staff in
            guard let self else { return }

            self.fetchedStaff = staff.data.filter { ($0.schedule_till ?? "") > self.currentDate() }
            self.view?.showIndicator(false)
            self.view?.reloadData()
        }
    }

    private func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }

    private func fetchBookStaff(company_id: Int, serviceID: Int) {
        view?.showIndicator(true)
        network.performRequest(
            type: .bookStaff(
                company_id: company_id,
                service_id: [serviceID]),
            expectation: EmployeeModel.self)
        { [weak self] staff in
            guard let self else { return }

            self.fetchedStaff = staff.data.filter { ($0.schedule_till ?? "") > self.currentDate() }
            self.view?.showIndicator(false)
            self.view?.reloadData()
        }
    }
}
