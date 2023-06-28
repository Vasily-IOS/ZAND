//
//  SettingsViewController.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import UIKit

final class SettingsViewController: BaseViewController<SettingsView> {

    // MARK: - Lifecycle

    override func loadView() {
        super.loadView()
        setNavBar()
    }
}

extension SettingsViewController {
    
    // MARK: - Instance methods
    
    private func setNavBar() {
        title = StringsAsset.settings
    }
}
