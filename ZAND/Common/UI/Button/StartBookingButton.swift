//
//  StartBookingButton.swift
//  ZAND
//
//  Created by Василий on 18.09.2023.
//

import UIKit

final class StartBookingButton: UIButton {

    // MARK: - Initializers

    init(title: String) {
        super.init(frame: .zero)

        setup(title: title)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Instance methods

    private func setup(title: String) {
        setTitle(title, for: .normal)
        layer.cornerRadius = 15.0
        backgroundColor = .white
        setTitleColor(.black, for: .normal)
        titleLabel?.textAlignment = .center
        titleLabel?.numberOfLines = 0
    }
}
