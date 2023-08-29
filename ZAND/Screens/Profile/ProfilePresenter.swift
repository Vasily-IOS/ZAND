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
    func checkLogIn()
    func signOut()
}

protocol ProfileViewInput: AnyObject {
    func updateWithLoggedData(model: UserModel)
}

final class ProfilePresenter: ProfilePresenterOutput {

    // MARK: - Properties

    weak var view: ProfileViewInput?

    private let profileMenuModel = ProfileMenuModel.model

    private let realmManager: RealmManager

    private let uDmanager: UDManagerImpl = UDManager()

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

    func checkLogIn() {
        if let model = uDmanager.loadElement(to: UserModel.self, Config.userData) {
            view?.updateWithLoggedData(model: model)
        }
    }

    func signOut() {
        uDmanager.deleteElement(by: Config.userData)
        AppRouter.shared.switchRoot(type: .signIn)
        AGСConnectManagerImpl.shared.signOut()
    }
}
