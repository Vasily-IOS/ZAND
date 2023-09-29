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
    var saloonID: Int { get }
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

    let saloonID: Int

    let serviceToProvideID: Int

    private let network: HTTP

    // MARK: - Initializers

    init(
        view: StaffViewInput,
        saloonID: Int,
        network: HTTP,
        serviceToProvideID: Int,
        viewModel: ConfirmationViewModel)
    {
        self.view = view
        self.saloonID = saloonID
        self.network = network
        self.viewModel = viewModel
        self.serviceToProvideID = serviceToProvideID

        if serviceToProvideID == 0 {
            self.fetchStaff()
        } else {
            self.fetchBookStaff(saloonID: saloonID, serviceID: serviceToProvideID)
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
                company_id: saloonID,
                service_id: []),
            expectation: EmployeeModel.self)
        { [weak self] staff in
            guard let self else { return }

            self.fetchedStaff = staff.data
            self.view?.showIndicator(false)
            self.view?.reloadData()
        }
    }

    private func currentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: Date())
    }

    private func fetchBookStaff(saloonID: Int, serviceID: Int) {
        view?.showIndicator(true)
        network.performRequest(
            type: .bookStaff(
                company_id: saloonID,
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
