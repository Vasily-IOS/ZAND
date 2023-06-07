//
//  HideNavigationBar.swift
//  ZAND
//
//  Created by Василий on 05.06.2023.
//

import UIKit

protocol HideNavigationBar {
    var navController: UINavigationController? { get }
    func hideNavigationBar()
}

extension HideNavigationBar where Self: UIViewController {
    
    func hideNavigationBar() {
        if let navController = navController {
            navController.isNavigationBarHidden = true
        }
    }
}
