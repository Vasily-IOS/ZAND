//
//  DefaultVCFactory.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

protocol ViewControllerFactory: AnyObject {
    func getViewController(for type: VCType) -> UIViewController
}
