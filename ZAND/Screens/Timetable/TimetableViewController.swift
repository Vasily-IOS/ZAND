//
//  TimetableViewController.swift
//  ZAND
//
//  Created by Василий on 23.09.2023.
//

import UIKit

final class TimetableViewController: BaseViewController<TimetableView> {

    // MARK: - Properties

    var presenter: TimetablePresenterOutput?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        title = AssetString.selectDateAndTime
    }
}

extension TimetableViewController: TimetableInput {

    // MARK: - TimetableInput methods

}
