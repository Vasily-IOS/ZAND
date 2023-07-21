//
//  DefaultVCFactory.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

protocol DefaultVCFactory: AnyObject {
    func getViewController(for type: VCType) -> UIViewController
}
