//
//  SelectableMapViewController.swift
//  ZAND
//
//  Created by Василий on 22.05.2023.
//

import UIKit

final class SelectableViewController: BaseViewController<SelectableMapView> {
    
    // MARK: - Properties
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }

    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        showNavigationBar()
    }
    
    deinit {
        print("MapVC died")
    }
}

extension SelectableViewController: ShowNavigationBar {}
