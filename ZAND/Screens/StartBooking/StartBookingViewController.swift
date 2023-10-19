//
//  StartBookingViewController.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import UIKit

final class StartBookingViewController: BaseViewController<StartBookingView> {

    // MARK: - Properties

    var presenter: StartBookingPresenterOutput?

    // MARK: - Initializers

    override func viewDidLoad() {
        super.viewDidLoad()

        hideBackButtonTitle()
        subscribeDelegate()
    }

    deinit {
        print("StartBookingViewController died")
    }

    // MARK: - Instance methods

    private func subscribeDelegate() {
        contentView.delegate = self
    }
}

extension StartBookingViewController: StartBookingDelegate {

    // MARK: - StartBookingDelegate methods

    func openServices() {
        AppRouter.shared.pushCreateRecord(.services(
            booking_type: .service,
            company_id: presenter?.company_id ?? 0,
            company_name: presenter?.companyName ?? "",
            company_address: presenter?.saloonAddress ?? "")
        )
    }

    func openStaff() {
        AppRouter.shared.pushCreateRecord(.staff(
            booking_type: .staff,
            company_id: presenter?.company_id ?? 0,
            company_name: presenter?.companyName ?? "",
            company_address: presenter?.saloonAddress ?? "")
        )
    }
}

extension StartBookingViewController: StartBookingViewInput, HideBackButtonTitle {}
