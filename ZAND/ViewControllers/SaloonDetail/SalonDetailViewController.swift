//
//  SalonDetailViewController.swift
//  ZAND
//
//  Created by Василий on 21.04.2023.
//

import UIKit
import SnapKit

final class SaloonDetailViewController: BaseViewController<UIView> {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    deinit {
        print("SaloonDetailViewController died")
    }
        
    private func setupNavigationbar() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        
        if #available(iOS 15, *) {
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowColor = .clear
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
            navigationController?.navigationBar.tintColor = .white
        } else {
            navigationController?.navigationBar.shadowImage = UIImage()
        }
        
        navigationController?.navigationBar.tintColor = UIColor(red: 0, green: 0, blue: 0.2, alpha: 1)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

