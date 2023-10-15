//
//  StartBookingPresenter.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import Foundation

protocol StartBookingPresenterOutput: AnyObject {
    var company_id: Int { get }
    var companyName: String { get }
    var saloonAddress: String { get }
}

protocol StartBookingViewInput: AnyObject {}

final class StartBookingPresenter: StartBookingPresenterOutput {

    // MARK: - Properties

    weak var view: StartBookingViewInput?
    
    let company_id: Int

    let companyName: String

    let saloonAddress: String

    // MARK: - Initializers

    init(
        view: StartBookingViewInput,
        company_id: Int,
        companyName: String,
        saloonAddress: String
    ) {
        self.view = view
        self.company_id = company_id
        self.companyName = companyName
        self.saloonAddress = saloonAddress
    }

    deinit {
        print("StartBookingPresenterOutput died")
    }
}
