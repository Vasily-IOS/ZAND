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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupBackButtonItem()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backViewAction()
        subscribeDelegate()
        hideBackButtonTitle()

        presenter?.updateUI()
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

    func updateUI(model: SaloonMockModel) {
        contentView.configure(model: model)
    }
}

extension SaloonDetailViewController: SaloonDetailDelegate {

    // MARK: - SaloonDetailDelegate methods

    func openMap() {
        guard let model = presenter?.getModel() else { return }

        AppRouter.shared.push(.selectableMap(model))
    }

    func openBooking() {
        AppRouter.shared.presentWithNav(type: .booking)
    }
}

extension SaloonDetailViewController: HideBackButtonTitle {}
