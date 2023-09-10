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
    func getDBmodel() -> [SaloonDataBaseModel]
    func checkLogIn()
    func signOut()
}

protocol ProfileViewInput: AnyObject {
    func updateWithLoggedData(model: UserDataBaseModel)
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

    func getDBmodel() -> [SaloonDataBaseModel] {
        return Array(realmManager.get(SaloonDataBaseModel.self))
    }

    func checkLogIn() {
        if let user = UserDBManager.shared.get() {
            view?.updateWithLoggedData(model: user)
        }
    }

    func signOut() {
        UserDBManager.shared.exit()
        AppRouter.shared.switchRoot(type: .signIn)
    }
}
