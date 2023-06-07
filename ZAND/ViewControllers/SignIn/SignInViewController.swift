//
//  SignInViewController.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit

final class SignInViewController: BaseViewController<UIView> {
    
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
        print("SignInViewController died")
    }
}

extension SignInViewController: HideNavigationBar {}
