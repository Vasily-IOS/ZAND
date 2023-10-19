//
//  ActivityIndicatorView.swift
//  ZAND.
//
//  Created by Василий on 25.07.2023.
//

import UIKit
import SnapKit

protocol ActivityIndicatorImpl: UIView {
    func startAnimating()
    func stopAnimating()
}

final class ActivityIndicatorView: BaseUIView {

    // MARK: - Properties

    private let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.style = .medium
        return activityIndicatorView
    }()

    // MARK: - Instance methods

    override func setup() {
        super.setup()

        setViews()
    }

    func setViews() {
        addSubview(activityIndicatorView)

        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

extension ActivityIndicatorView: ActivityIndicatorImpl {

    // MARK: - ActivityIndicatorImpl methods

    func startAnimating() {
        activityIndicatorView.startAnimating()
    }

    func stopAnimating() {
        activityIndicatorView.stopAnimating()
    }
}
