//
//  RegisterNView.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import UIKit
import SnapKit

protocol RegisterDelegate: AnyObject {
    func cancelEditing()
    func register()
    func showPolicy()
    func changePolicy(isConfirmed: Bool)
}

final class RegisterView: BaseUIView {

    // MARK: - Properties

    weak var delegate: RegisterDelegate?

    let phoneTextField: PaddingTextField = {
        let phoneTextField = PaddingTextField(state: .phone)
        phoneTextField.text = "+7"
        phoneTextField.layer.borderColor = UIColor.red.cgColor
        phoneTextField.layer.borderWidth = 0.5
        return phoneTextField
    }()

    let scrollView = UIScrollView()

    let nameTextField = PaddingTextField(state: .name)

    let surnameTextField = PaddingTextField(state: .surname)

    let emailTextField = PaddingTextField(state: .email)

    let policySwitchControl = UISwitch()

    private let agreeButton: UIButton = {
        let policyButton = UIButton()
        policyButton.setTitle("Согласен с", for: .normal)
        policyButton.setTitleColor(.black, for: .normal)
        policyButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .medium)
        return policyButton
    }()

    private let policyButton: UIButton = {
        let policyButton = UIButton()

        let yourAttributes: [NSAttributedString.Key: Any] = [
              .font: UIFont.systemFont(ofSize: 12),
              .foregroundColor: UIColor.mainGreen,
              .underlineStyle: NSUnderlineStyle.single.rawValue
          ]

        let attributeString = NSMutableAttributedString(
                string: "политикой конфиденциальности",
                attributes: yourAttributes
             )

        policyButton.setAttributedTitle(attributeString, for: .normal)
        return policyButton
    }()

    private let saveButton = BottomButton(buttonText: .save)

    private let entranceLabel = UILabel(
        .systemFont(ofSize: 24, weight: .bold),
        .black,
        AssetString.registation.rawValue
    )

    private lazy var policyButtonsStackView = UIStackView(
        alignment: .leading,
        arrangedSubviews: [agreeButton, policyButton],
        axis: .vertical,
        distribution: .fillProportionally
    )

    lazy var interiorStackView = UIStackView(
        alignment: .fill,
        arrangedSubviews: [nameTextField,
                           surnameTextField,
                           emailTextField,
                           phoneTextField],
        axis: .vertical,
        distribution: .fillEqually,
        spacing: 16
    )

    private lazy var baseStackView = UIStackView(
        alignment: .center,
        arrangedSubviews: [entranceLabel,
                           interiorStackView],
        axis: .vertical,
        distribution: .fill,
        spacing: 30
    )

    private lazy var policyStackView = UIStackView(
        alignment: .leading,
        arrangedSubviews: [
            policyButtonsStackView,
            policySwitchControl
        ],
        axis: .horizontal,
        spacing: 5
    )

    private let contentView = UIView()

    // MARK: - Instance methods

    override func setup() {
        super.setup()

        setViews()
        setRecognizer()
        setTargets()
    }

    func hidePhoneKeyboard() {
        phoneTextField.resignFirstResponder()
    }

    func makeRedBorder() {
        phoneTextField.layer.borderColor = UIColor.red.cgColor
        phoneTextField.layer.borderWidth = 0.5
    }

    func removeBorder() {
        phoneTextField.layer.borderWidth = 0.0
    }

    func configure(model: UserModel) {
        nameTextField.configure(textInput: model.name)
        surnameTextField.configure(textInput: model.surname)
        emailTextField.configure(textInput: model.email)
    }

    // MARK: - Action

    @objc
    private func cancelEditingAction() {
        delegate?.cancelEditing()
    }

    @objc
    private func registerAction() {
        delegate?.register()
    }

    @objc
    private func openPolicyAction() {
        delegate?.showPolicy()
    }

    @objc
    private func switchAction(_ sender: UISwitch) {
        delegate?.changePolicy(isConfirmed: sender.isOn)
    }
}

extension RegisterView {

    // MARK: - Instance methods

    private func setViews() {
        backgroundColor = .mainGray
        policyButtonsStackView.sizeToFit()

        addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubviews([baseStackView, policyStackView, saveButton])

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        [nameTextField, surnameTextField, emailTextField, phoneTextField].forEach {
            $0.snp.makeConstraints { make in
                make.left.equalTo(self.snp.left).offset(16)
                make.right.equalTo(self.snp.right).inset(16)
            }
        }

        baseStackView.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(170)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }

        policyStackView.snp.makeConstraints { make in
            make.top.equalTo(baseStackView.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview().inset(16)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(policyStackView.snp.bottom).offset(60)
            make.width.equalTo(interiorStackView)
            make.height.equalTo(44)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(40)
        }
    }

    private func setRecognizer() {
        addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(cancelEditingAction)
            )
        )
    }

    private func setTargets() {
        saveButton.addTarget(
            self,
            action: #selector(registerAction),
            for: .touchUpInside
        )

        policyButton.addTarget(
            self,
            action: #selector(openPolicyAction),
            for: .touchUpInside
        )

        policySwitchControl.addTarget(
            self,
            action: #selector(switchAction),
            for: .valueChanged
        )
    }
}
