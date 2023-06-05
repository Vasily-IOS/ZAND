//
//  RegisterViewController.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit

final class RegisterViewController: BaseViewController<UIView> {
    
    // MARK: - Properties
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }
    
//    override func loadView() {
//        super.loadView()
//        showNavigationBar()
//    }
    
    deinit {
        print("RegisterViewController died")
    }
}

extension RegisterViewController: ShowNavigationBar {}
