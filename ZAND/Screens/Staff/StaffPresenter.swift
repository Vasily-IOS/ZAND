//
//  StaffPresenter.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import Foundation

protocol StaffPresenterOutput: AnyObject {
    var viewModel: ConfirmationViewModel { get set }
    var serviceToProvideID: Int { get }
    var company_id: Int { get }
    var fetchedStaff: [EmployeeCommon] { get }

    func fetchStaff()
    func setStaffID(staffID: Int)
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

    let company_id: Int

    let serviceToProvideID: Int

    private let network: APIManager

    // MARK: - Initializers

    init(
        view: StaffViewInput,
        company_id: Int,
        network: APIManager,
        serviceToProvideID: Int=0,
        viewModel: ConfirmationViewModel)
    {
        self.view = view
        self.company_id = company_id
        self.network = network
        self.viewModel = viewModel
        self.serviceToProvideID = serviceToProvideID

        switch viewModel.bookingType {
        case .service:
            self.fetchBookStaff(company_id: company_id, serviceID: serviceToProvideID)
        case .staff:
            self.fetchStaff()
        }
    }

    deinit {
        print("StaffPresenter died")
    }

    // MARK: - Instance methods

    func setStaffID(staffID: Int) {
        print()
    }

    func fetchStaff() {
        view?.showIndicator(true)
        network.performRequest(
            type: .bookStaff(
                company_id: company_id,
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
