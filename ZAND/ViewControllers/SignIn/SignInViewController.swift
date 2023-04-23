//
//  SignInViewController.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit

final class SignInViewController: BaseViewController<UIView> {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}
