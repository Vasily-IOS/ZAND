//
//  SignInViewController.swift
//  ZAND
//
//  Created by Василий on 23.04.2023.
//

import UIKit

final class SignInViewController: BaseViewController<SignInView> {
    
    // MARK: - Properties

    var presenter: SignInPresenterOutput?
    
    var navController: UINavigationController? {
        return self.navigationController ?? UINavigationController()
    }

    var activityIndicatorView: ActivityIndicatorImpl = ActivityIndicatorView()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        hideNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegate()
    }
    
    deinit {
        print("SignInViewController died")
    }

    // MARK: - Instance methods

    private func subscribeDelegate() {
        contentView.delegate = self
        [contentView.nameTextField,
         contentView.phoneTextField,
         contentView.smsCodeTextField].forEach {
            $0.delegate = self
        }
    }
}

extension SignInViewController: SignInDelegate {

    // MARK: - SignInDelegate methods

    func stopEditing() {
        contentView.endEditing(true)
    }

    func navigateToRegister() {
        AppRouter.shared.push(.register)
    }

    func signIn() {
        if !presenter!.codeAreSuccessfullySended {
            presenter?.enterNamePhone()
            showIndicator()
        } else {
            showIndicator()
            presenter?.enterSmsCode()
        }
    }
}

extension SignInViewController: UITextFieldDelegate {

    // MARK: - UITextFieldDelegate methods

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == contentView.phoneTextField {
            let fullNumber = (textField.text ?? "") + string
            textField.text = fullNumber.numberCorrector(phoneNumber: fullNumber,
                                                        shouldRemoveLastDigit: range.length == 1)
            if fullNumber.count == 18 {
                contentView.hidePhoneKeyboard()
            }
            return false
        }
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        let text = textField.text ?? ""

        switch textField {
        case contentView.nameTextField:
            presenter?.registerModel.name = text
        case contentView.phoneTextField:
            presenter?.registerModel.phone = text
        case contentView.smsCodeTextField:
            if text.count == 6 {
                contentView.hideSmsCodeKeyboard()
            }
            presenter?.registerModel.verifyCode = text
        default:
            break
        }
    }
}

extension SignInViewController: SignInViewInput {

    // MARK: - SignInViewInput methods

    func showAlert(type: AlertType, message: String?) {
        AppRouter.shared.showAlert(type: type, message: message)
    }

    func updateUI(state: RegisterViewState) {
        switch state {
        case .sendCode:
            hideIndicator()
            contentView.updateUI()
        case .showProfile:
            hideIndicator()
            AppRouter.shared.switchRoot(type: .profile)
        case .backToTop:
            hideIndicator()
            contentView.initialStartMode()
        }
    }

    func dismiss() {
        AppRouter.shared.popViewController()
    }
}

extension SignInViewController: ActivityIndicator, HideNavigationBar {}
