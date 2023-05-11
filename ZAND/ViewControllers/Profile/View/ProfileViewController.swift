//
//  ThirdViewController.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

final class ProfileViewController: BaseViewController<UIView> {
    
    override func loadView() {
        super.loadView()
        setNavBar()
    }
 
    deinit {
        print("ProfileViewController died")
    }
}

extension ProfileViewController {
    
    // MARK: - Instance methods
    
    private func setNavBar() {
        navigationController?.isNavigationBarHidden = false
        let backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
    }
}
