//
//  RegisterNViewController.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import UIKit

final class RegisterNViewController: BaseViewController<RegisterNView> {

    // MARK: - Properties

    var presenter: RegisterNPresenterOutput?

    // MARK: - Initializers

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        subscribeDelegates()
    }

    // MARK: - Instance methods

    private func subscribeDelegates() {
        contentView.delegate = self
    }
}

extension RegisterNViewController: RegisterNDelegate {

    // MARK: - RegisterNDelegate methods
    
    func cancelEditing() {
        contentView.endEditing(true)
    }
}

extension RegisterNViewController: RegisterNViewInput {}
