//
//  SelectableMapViewController.swift
//  ZAND
//
//  Created by Василий on 22.05.2023.
//

import UIKit

final class SelectableViewController: BaseViewController<SelectableMapView> {

    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        setNavBar()
    }
    
    deinit {
        print("MapVC died")
    }

    // MARK: - Instance methods
}

extension SelectableViewController {
    
    // MARK: - Instance methods
    
    private func setNavBar() {
        navigationController?.isNavigationBarHidden = false
    }
    
}
