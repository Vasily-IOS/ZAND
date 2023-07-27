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

    var presenter: SaloonPresenterOutput?
    
    private let backView = BackView()
 
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backViewAction()
        subscribeDelegate()
        hideBackButtonTitle()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupBackButtonItem()
        presenter?.isInFavourite()
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
    
    private func setupBackButtonItem() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backView)
    }
    
    private func subscribeDelegate() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        contentView.delegate = self
    }
}

extension SaloonDetailViewController: UIGestureRecognizerDelegate {
    
    // MARK: - UIGestureRecognizerDelegate methods
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        guard (otherGestureRecognizer as? UIPanGestureRecognizer) != nil else {
            return true
        }
        return false
    }
}

extension SaloonDetailViewController: SaloonViewInput {

    // MARK: - SaloonViewInput methods

    func updateUI(type: SaloonDetailType) {
        contentView.configure(type: type)
    }

    func isInFavourite(result: Bool) {
        contentView.inFavourite = !result
    }
}

extension SaloonDetailViewController: SaloonDetailDelegate {

    // MARK: - SaloonDetailDelegate methods

    func openMap() {
        if let model = presenter?.getModel() {
            AppRouter.shared.presentWithNav(type: .selectableMap(model))
        } else if let dbModel = presenter?.getDBModel() {
            AppRouter.shared.presentWithNav(type: .selectableMap(dbModel))
        }
    }

    func openBooking() {
        if AuthManagerImpl.shared.currentUser == nil {
            AppRouter.shared.popViewController()
            AppRouter.shared.changeTabBarVC(to: 2)
        } else {
            AppRouter.shared.presentWithNav(type: .booking)
        }
    }

    func applyDB() {
        if AuthManagerImpl.shared.currentUser == nil {
            AppRouter.shared.popViewController()
            AppRouter.shared.changeTabBarVC(to: 2)
        } else {
            presenter?.applyDB {
                contentView.inFavourite = !contentView.inFavourite
            }
        }
    }
}

extension SaloonDetailViewController: HideBackButtonTitle {}
