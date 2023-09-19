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

        title = AssetString.howStart

        hideBackButtonTitle()
        subscribeDelegate()
    }

    // MARK: - Instance methods

    private func subscribeDelegate() {
        contentView.delegate = self
    }
}

extension StartBookingViewController: StartBookingDelegate {

    // MARK: - StartBookingDelegate methods

    func openServices() {
        let view = ServicesView()
        let vc = ServicesViewController(contentView: view)
        let network: HTTP = APIManager()
        let presenter = ServicesPresenter(view: vc, saloonID: presenter?.saloonID ?? 0, network: network)
        vc.presenter = presenter
        navigationController?.pushViewController(vc, animated: true)
    }

    func openStaff() {
        let view = StaffView()
        let vc = StaffViewController(contentView: view)
        let network: HTTP = APIManager()
        let presenter = StaffPresenter(view: vc, saloonID: presenter?.saloonID ?? 0, network: network)
        vc.presenter = presenter
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension StartBookingViewController: StartBookingViewInput {}

extension StartBookingViewController: HideBackButtonTitle {}
