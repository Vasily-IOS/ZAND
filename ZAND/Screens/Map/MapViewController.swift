//
//  SecondViewController.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

final class MapViewController: BaseViewController<UIView> {
    
    // MARK: - Properties
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }

    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }
    
    deinit {
        print("MapViewController died")
    }
}

extension MapViewController: HideNavigationBar {}