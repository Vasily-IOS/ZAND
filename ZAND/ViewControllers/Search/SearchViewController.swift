//
//  SearchViewController.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

final class SearchViewController: BaseViewController<UIView> {
    
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
        print("SearchViewController died")
    }
}

extension SearchViewController: HideNavigationBar {}
