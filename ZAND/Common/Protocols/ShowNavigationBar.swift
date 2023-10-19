//
//  ShowsNavigationBar.swift
//  ZAND
//
//  Created by Василий on 05.06.2023.
//

import UIKit

protocol ShowNavigationBar {
    var navController: UINavigationController? { get }
    func showNavigationBar()
}

extension ShowNavigationBar where Self: UIViewController {
    
    func showNavigationBar() {
        if let navController = navController {
            navController.isNavigationBarHidden = false
        }
    }
}
