//
//  StaffPresenter.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import Foundation

protocol StaffPresenterOutput: AnyObject {
    func fetchStaff()
    var saloonID: Int { get }
    var fetchedStaff: [EmployeeCommon] { get }
}

protocol StaffViewInput: AnyObject {
    func reloadData()
}

final class StaffPresenter: StaffPresenterOutput {

    // MARK: - Properties

    weak var view: StaffViewInput?

    var fetchedStaff: [EmployeeCommon] = []

    let saloonID: Int

    private let staffID: [Int]

    private let network: HTTP

    // MARK: - Initializers

    init(view: StaffViewInput, saloonID: Int, network: HTTP, staffIDs: [Int] = []) {
        self.view = view
        self.saloonID = saloonID
        self.network = network
        self.staffID = staffIDs

        if staffID.isEmpty {
            self.fetchStaff()
        } else {
            self.fetchStaffByID(staffIDs: staffIDs)
        }
    }

    // MARK: - Instance methods

    private func fetchStaffByID(staffIDs: [Int]) {
        let group = DispatchGroup()

        staffIDs.forEach { id in
            group.enter()
            DispatchQueue.global().async {
                self.getEmployee(saloonID: self.saloonID, staff_id: id) { employee in
                    self.fetchedStaff.append(employee)
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            self.view?.reloadData()
        }
    }

    func fetchStaff() {
        network.performRequest(type: .staff(company_id: saloonID), expectation: EmployeeModel.self)
        { [weak self] result in
            let resultStaff = result.data.filter({ $0.fired == 0 && $0.hidden == 0 })
            self?.fetchedStaff = resultStaff

            self?.view?.reloadData()
        }
    }

    private func getEmployee(saloonID: Int, staff_id: Int, completion: @escaping ((EmployeeCommon) -> Void)) {
        network.performRequest(
            type: .staffByID(company_id: saloonID, staff_id: staff_id),
            expectation: SingleEmployeeModel.self) { employee in
                completion(employee.data)
            }
    }
}
