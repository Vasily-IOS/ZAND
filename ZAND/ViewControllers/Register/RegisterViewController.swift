//
//  RegisterViewController.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit

final class RegisterViewController: BaseViewController<RegisterView> {
    
    // MARK: - Properties
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeDelegate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
    }
 
    deinit {
        print("RegisterViewController died")
    }
    
    // MARK: - Instance methods
    
    private func subscribeDelegate() {
        contentView.delegate = self
    }
    
    private func sendNotify() {
        NotificationCenter.default.post(name: .showTabBar, object: nil)
    }
}

extension RegisterViewController: RegisterViewDelegate {
    
    // MARK: - Instance methods
    
    func skip() {
        removeFromParent()
        willMove(toParent: nil)
        view.removeFromSuperview()
        sendNotify()
        OnboardManager.shared.setIsNotNewUser()
    }
}

extension RegisterViewController: ShowNavigationBar {}
