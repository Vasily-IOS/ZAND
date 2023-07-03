//
//  ProfilePresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import Foundation
import RealmSwift

enum ProfileType {
    case profileFields
    case favourites
}

protocol ProfilePresenterOutput: AnyObject {
    func getMenuModel() -> [ProfileMenuModel]
    func getDBmodel() -> [DetailModelDB]
}

protocol ProfileViewInput: AnyObject {

}

final class ProfilePresenter: ProfilePresenterOutput {

    // MARK: - Properties

    weak var view: ProfileViewInput?

    private let profileMenuModel = ProfileMenuModel.model

    private let realmManager: RealmManager

    // MARK: - Initializers

    init(view: ProfileViewInput, realmManager: RealmManager) {
        self.view = view
        self.realmManager = realmManager
    }

    func getMenuModel() -> [ProfileMenuModel] {
        return profileMenuModel
    }

    func getDBmodel() -> [DetailModelDB] {
        return Array(realmManager.get(DetailModelDB.self))
    }
}
