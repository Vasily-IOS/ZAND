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
        [contentView.nameTextField,
         contentView.phoneTextField,
         contentView.smsCodeTextField
        ].forEach {
            $0.delegate = self
        }
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

    func register() {
        if !presenter!.codeAreSuccessfullySended {
            presenter?.enterNamePhone()
        } else {
            presenter?.enterSmsCode()
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {

    // MARK: - UITextFieldDelegate methods

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == contentView.phoneTextField {
            guard let text = textField.text else { return false }

            let phoneString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = text.format(with: "+X (XXX) XXX-XX-XX", phone: phoneString)

            if (textField.text?.count ?? 0) == 18 && (presenter?.keyboardAlreadyHidined ?? false) == false {
                presenter?.keyboardAlreadyHidined = true
                contentView.hidePhoneKeyboard()
            }

            return false
        }
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""

        switch textField {
        case contentView.phoneTextField:
            let result = text.filter("0123456789.".contains).dropFirst()
            presenter?.registerModel.phone = String(result)
        case contentView.smsCodeTextField:
            presenter?.registerModel.verifyCode = text
        default:
            break
        }
    }
}

extension RegisterViewController: RegisterViewInput {

    // MARK: - RegisterViewInput methods

    func showAlert(type: AlertType) {
        AppRouter.shared.showAlert(type: type, message: nil)
    }

    func updateUI(state: RegisterViewState) {
        switch state {
        case .sendCode:
            contentView.updateUI()
        case .showProfile:
            print("Show profile")
            contentView.backgroundColor = .systemTeal
        case .backToTop:
            break
        }
    }

    func dismiss() {
        AppRouter.shared.popViewController()
    }
}

extension RegisterViewController: ShowNavigationBar {}
