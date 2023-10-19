//
//  ActivityIndicator.swift
//  ZAND.
//
//  Created by Василий on 25.07.2023.
//

import UIKit

protocol ActivityIndicator {
    var activityIndicatorView: ActivityIndicatorImpl { get }

    func showIndicator()
    func hideIndicator()
}

extension ActivityIndicator where Self: UIViewController {

    func showIndicator() {
        view.addSubview(activityIndicatorView)

        activityIndicatorView.frame = view.bounds
        activityIndicatorView.startAnimating()
    }

    func hideIndicator() {
        activityIndicatorView.removeFromSuperview()
        activityIndicatorView.stopAnimating()
    }
}
