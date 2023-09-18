//
//  StaffPresenter.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import Foundation

protocol StaffPresenterOutput: AnyObject {
    func fetchStaff()
    var staff: [Employee] { get }
}

protocol StaffViewInput: AnyObject {
    func reloadData()
}

final class StaffPresenter: StaffPresenterOutput {

    // MARK: - Properties

    weak var view: StaffViewInput?

    var staff: [Employee] = []

    private let network: HTTP

    private let saloonID: Int

    // MARK: - Initializers

    init(view: StaffViewInput, saloonID: Int, network: HTTP) {
        self.view = view
        self.saloonID = saloonID
        self.network = network
    }

    // MARK: - Instance methods

    func fetchStaff() {
        network.performRequest(type: .staff(saloonID), expectation: EmployeeModel.self)
        { [weak self] result in
            self?.staff = result.data
            self?.view?.reloadData()
        }
    }
}
