//
//  ThirdViewController.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

final class ProfileViewController: BaseViewController<ProfileView> {
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        setNavBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTargets()
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
    
    private func setTargets() {
        contentView.alertHandler = { [weak self] in
            self?.makeAlertController()
        }
    }
    
    private func makeAlertController() {
        let alertController = UIAlertController(title: StringsAsset.exitMessage,
                                                message: nil,
                                                preferredStyle: .alert)
        let noAction = UIAlertAction(title: StringsAsset.no, style: .cancel)
        let yesAction = UIAlertAction(title: StringsAsset.yes, style: .default)
        alertController.addAction(noAction)
        alertController.addAction(yesAction)
        present(alertController, animated: true)
    }
}
