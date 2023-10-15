//
//  DefaulRoter.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

protocol DefaultRouter: AnyObject {
    var appDelegate: AppDelegate? { get set}

    func present(type: VCType)
    func push(_ type: VCType)
    func changeTabBarVC(to index: Int)
    func popViewController()
    func dismiss()

    func pushCreateRecord(_ type: VCType)
    func showAlert(type: AlertType, message: String?)
    func presentCompletion(type: VCType, completion: @escaping ([IndexPath: Bool]) -> Void)
    func presentRecordNavigation(type: VCType)
    func presentSearch(type: VCType, completion: ((Saloon) -> ())?)
    func switchRoot(type: ReplacedControllerType)

    func checkAuth()
}
