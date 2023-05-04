//
//  SettingsViewController.swift
//  ZAND
//
//  Created by Василий on 04.05.2023.
//

import UIKit

final class SettingsViewController: BaseViewController<SettingsView> {
    
    override func loadView() {
        super.loadView()
        setNavBar()
    }
}

extension SettingsViewController {
    
    // MARK: - SettingsViewController
    
    private func setNavBar() {
        title = Strings.settings
    }
}
