//
//  StartBookingPresenter.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import Foundation

protocol StartBookingPresenterOutput: AnyObject {
    var saloonID: Int { get }
}

protocol StartBookingViewInput: AnyObject {}

final class StartBookingPresenter: StartBookingPresenterOutput {

    // MARK: - Properties

    weak var view: StartBookingViewInput?
    
    let saloonID: Int

    // MARK: - Initializers

    init(view: StartBookingViewInput, saloonID: Int) {
        self.view = view
        self.saloonID = saloonID
    }

    deinit {
        print("StartBookingPresenterOutput died")
    }
}
