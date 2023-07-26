//
//  DefaulRoter.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

protocol DefaultRouter: AnyObject {
    var appDelegate: AppDelegate? { get set}
    
    func push(_ type: VCType)
    func present(type: VCType)
    func changeTabBarVC(to index: Int)
    func popViewController()
    func dismiss()
    func showAlert(type: AlertType, message: String?)
    
    func presentWithNav(type: VCType)
    func presentSearch(type: VCType, completion: ((SaloonMockModel) -> ())?)

    func switchRoot(type: ReplacedControllerType)
    func checkAuth()
}
