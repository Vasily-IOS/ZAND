//
//  SalonDetailViewController.swift
//  ZAND
//
//  Created by Василий on 21.04.2023.
//

import UIKit
import SnapKit

final class SaloonDetailViewController: BaseViewController<SaloonDetailView> {
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationbar()
    }
    
    deinit {
        print("SaloonDetailViewController died")
    }
}

extension SaloonDetailViewController {
    
    // MARK: - Instance methods
    
    private func setupNavigationbar() {
        navigationController?.isNavigationBarHidden = false
    }
}
