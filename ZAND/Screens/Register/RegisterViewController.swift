//
//  RegisterViewController.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit

final class RegisterViewController: BaseViewController<RegisterView> {
    
    // MARK: - Properties

    var presenter: RegisterPresenterOutput?
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
        presenter?.setInitialState()
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

    func popViewController() {
        AppRouter.shared.popViewController()
    }

    func stopEditing() {
        contentView.endEditing(true)
    }

    func updateTo(state: RegistrationState) {
        presenter?.performUpdateUI(to: state)
    }
}

extension RegisterViewController: RegisterViewInput {

    // MARK: - RegisterViewInput methods

    func setInitialState(state: RegistrationState) {
        updateUI(by: state)
    }

    func updateUI(by state: RegistrationState) {
        contentView.state = state
        switch state {
        case .firstStep:
            contentView.entranceStackView.subviews.suffix(5).forEach {
                $0.isHidden = true
            }
        case .secondStep:
            let range = 3..<7
            for i in 0..<contentView.entranceStackView.subviews.count {
                if range.contains(i) {
                    contentView.entranceStackView.subviews[i].isHidden = false
                } else {
                    contentView.entranceStackView.subviews[i].isHidden = true
                }
            }
        case .thirdStep:
            contentView.entranceStackView.subviews.prefix(8).forEach {
                $0.isHidden = true
            }
            contentView.entranceStackView.subviews.suffix(1).forEach {
                $0.isHidden = false
            }
        }
    }
}

extension RegisterViewController: ShowNavigationBar {}
