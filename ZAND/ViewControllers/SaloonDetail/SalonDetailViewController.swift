//
//  SalonDetailViewController.swift
//  ZAND
//
//  Created by Василий on 21.04.2023.
//

import UIKit
import SnapKit

final class SaloonDetailViewController: BaseViewController<SaloonDetailView> {
    
    // MARK: - Properties
    
    private lazy var backView = BackView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        super.loadView()
        setupNavigationBar()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backViewAction()
        subscribeDelegate()
    }

    deinit {
        print("SaloonDetailViewController died")
    }
    
    // MARK: - Action
    
    private func backViewAction() {
        backView.didTapHandler = {
            AppRouter.shared.popViewController()
        }
    }
}

extension SaloonDetailViewController {
    
    // MARK: - Instance methods
    
    private func setupNavigationBar() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backView)
    }
    
    private func subscribeDelegate() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
}

extension SaloonDetailViewController: UIGestureRecognizerDelegate {
    
    // MARK: - UIGestureRecognizerDelegate methods
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard (otherGestureRecognizer as? UIPanGestureRecognizer) != nil else {
            return true
        }
        return false
    }
}
