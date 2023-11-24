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
    
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        guard (otherGestureRecognizer as? UIPanGestureRecognizer) != nil else {
            return true
        }
        return false
    }
}

extension SaloonDetailViewController: SaloonViewInput {

    // MARK: - SaloonViewInput methods

    func updateUI(model: Saloon) {
        contentView.configure(model: model)
    }

    func isInFavourite(result: Bool) {
        contentView.inFavourite = !result
    }
}

extension SaloonDetailViewController: SaloonDetailDelegate {

    // MARK: - SaloonDetailDelegate methods

    func openMap() {
        if let model = presenter?.getModel() {
            AppRouter.shared.presentRecordNavigation(type: .selectableMap(model))
        }
    }

    func openBooking() {
        if !UserDBManager.shared.isUserContains() {
            AppRouter.shared.popViewController()
            AppRouter.shared.changeTabBarVC(to: 2)
        } else {
            AppRouter.shared.presentRecordNavigation(
                type: .startBooking(
                    presenter?.salonID ?? 0,
                    presenter?.saloonName ?? "",
                    presenter?.saloonAddress ?? ""
                )
            )
        }
    }

    func applyDB() {
        if !UserDBManager.shared.isUserContains() {
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
