//
//  HideBackButtonTitle.swift
//  ZAND
//
//  Created by Василий on 05.06.2023.
//

import UIKit

protocol HideBackButtonTitle {
    func hideBackButtonTitle()
}

extension HideBackButtonTitle where Self: UIViewController {
    
    func hideBackButtonTitle() {
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
    }
}
