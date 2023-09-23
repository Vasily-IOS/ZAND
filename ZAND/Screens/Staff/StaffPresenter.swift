//
//  StaffPresenter.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import Foundation

//enum StaffAppearanceState {
//    case modelExist
//    case modelIsNotExist
//}

protocol StaffPresenterOutput: AnyObject {
    func fetchStaff()
    var saloonID: Int { get }
    var fetchedStaff: [Employee] { get }
}

protocol StaffViewInput: AnyObject {
    func reloadData()
}

final class StaffPresenter: StaffPresenterOutput {

    // MARK: - Properties

    weak var view: StaffViewInput?

    var fetchedStaff: [Employee] = []

    let saloonID: Int

    private let staffID: [Int]

    private let network: HTTP

    // MARK: - Initializers

    init(view: StaffViewInput, saloonID: Int, network: HTTP, staffID: [Int] = []) {
        self.view = view
        self.saloonID = saloonID
        self.network = network
        self.staffID = staffID

        if staffID.isEmpty {
            self.fetchStaff()
        } else {

        }
    }

    // MARK: - Instance methods

    func fetchStaff() {
        network.performRequest(type: .staff(company_id: saloonID), expectation: EmployeeModel.self)
        { [weak self] result in
            let resultStaff = result.data.filter({ $0.fired == 0 && $0.hidden == 0 })
            self?.fetchedStaff = resultStaff

            self?.view?.reloadData()
        }
    }

    func fetchEmployee(by staff_id: Int, completion: @escaping ((Employee) -> Void)) {
        network.performRequest(
            type: .staff(company_id: saloonID,
                         staff_id: staff_id),
            expectation: Employee.self) { [weak self] employee in
                completion(employee)
            }
    }
}
