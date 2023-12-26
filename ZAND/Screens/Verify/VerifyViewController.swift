//
//  VerifyViewController.swift
//  ZAND
//
//  Created by Василий on 26.12.2023.
//

import UIKit

final class VerifyViewController: BaseViewController<VerifyView> {

    var presenter: VerifyPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension VerifyViewController: VerifyInput {

}

