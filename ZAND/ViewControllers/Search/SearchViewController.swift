//
//  SearchViewController.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

final class SearchViewController: BaseViewController<UIView> {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    deinit {
        print("SearchViewController died")
    }
    
}
