//
//  AppointmentsViewController.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import UIKit

final class AppointmentsViewController: BaseViewController<AppointemtsView> {
    
    override func loadView() {
        super.loadView()
        setNavBar()
    }
}

extension AppointmentsViewController {
    
    // MARK: - Instance methods
    
    private func setNavBar() {
        title = StringsAsset.books
    }
}
