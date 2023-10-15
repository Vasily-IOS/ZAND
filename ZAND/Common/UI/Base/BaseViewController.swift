//
//  BaseViewController.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

class BaseViewController<View: UIView>: UIViewController {

    // MARK: - Properties
    
    let contentView: View

    // MARK: - Initializers
    
    init(contentView: View) {
        self.contentView = contentView
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()

        view = contentView
    }
}
