//
//  File.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

final class MainViewController: BaseViewController<UIView> {
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        setupNavigationBar()
    }

    deinit {
        print("MainViewController died")
    }
}

extension MainViewController {
    
    // MARK: - Instance methods
    
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = true
    }
}
