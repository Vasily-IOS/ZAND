//
//  Extension + UIViewController.swift
//  ZAND
//
//  Created by Василий on 30.06.2023.
//

import UIKit
import SnapKit

extension UIViewController {
    func addChildren(viewController: UIViewController) {
        addChild(viewController)
        viewController.didMove(toParent: self)
        view.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
}
