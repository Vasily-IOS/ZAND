//
//  ProfilePresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation

enum ProfileType {
    case profileFields
    case favourites
}

protocol ProfilePresenterOutput: AnyObject {
    func getMenuModel() -> [ProfileMenuModel]
    func getDBmodel() -> [SaloonMockModel]
}

protocol ProfileViewInput: AnyObject {

}

final class ProfilePresenter: ProfilePresenterOutput {

    // MARK: - Properties

    weak var view: ProfileViewInput?

    private let profileMenuModel = ProfileMenuModel.model

    // should be data base model!
    private let saloonMockModel = SaloonMockModel.saloons

    // MARK: - Initializers

    init(view: ProfileViewInput) {
        self.view = view
    }

    func getMenuModel() -> [ProfileMenuModel] {
        return profileMenuModel
    }

    func getDBmodel() -> [SaloonMockModel] {
        return saloonMockModel
    }
}
