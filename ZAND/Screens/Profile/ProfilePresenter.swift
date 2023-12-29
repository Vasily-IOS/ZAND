//
//  ProfilePresenter.swift
//  ZAND
//
//  Created by Василий on 28.06.2023.
//

import UIKit
import RealmSwift

enum ProfileType {
    case profileFields
    case favourites
}

protocol ProfilePresenterOutput: AnyObject {
    func getMenuModel() -> [ProfileMenuModel]
    func updateSavedSaloons()
    func updateProfile()
    func signOut()
    func deleteUser()
}

protocol ProfileViewInput: AnyObject {
    func updateProfile(model: UserDataBaseModel)
    func updateWithSaloons(model: [Saloon])
    func showSuccessAlert()
    func showFailureAlert()
}

final class ProfilePresenter: ProfilePresenterOutput {

    // MARK: - Properties

    unowned let view: ProfileViewInput

    private let profileMenuModel = ProfileMenuModel.model

    private var uiModelCount: Int = 0

    private let network: APIManagerCommonP

    private let authNetwork: APIManagerAuthP

    // MARK: - Initializers

    init(view: ProfileViewInput, network: APIManagerCommonP, authNetwork: APIManagerAuthP) {
        self.view = view
        self.network = network
        self.authNetwork = authNetwork

        subscribeNotification()

        updateProfile()

        if !FavouritesSalonsManager.shared.storageID.isEmpty {
            updateSavedSaloons()
        }
    }

    // MARK: - Instance methods

    func getMenuModel() -> [ProfileMenuModel] {
        return profileMenuModel
    }

    func updateSavedSaloons() {
        let saloonsID = FavouritesSalonsManager.shared.storageID
        var savedSaloons: [Saloon?] = Array(repeating: nil, count: saloonsID.count)
        let group = DispatchGroup()

        for (index, value) in saloonsID.enumerated() {
            group.enter()
            network.performRequest(type: .salons, expectation: SalonsCodableModel.self) { saloonData in
                let saloon = saloonData.data.first(where: { $0.id == value })
                if let saloon {
                    savedSaloons[index] = SaloonModel(saloonCodable: saloon)
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.view.updateWithSaloons(model: savedSaloons.compactMap({ $0 }))
        }
    }

    func updateProfile() {
        if let user = UserDBManager.shared.get() {
            view.updateProfile(model: user)
        }
    }

    // sign out явный из профиля
    func signOut() {
        UserDBManager.shared.delete()
        TokenManager.shared.deleteToken()

        DispatchQueue.main.async {
            AppRouter.shared.switchRoot(type: .signIn)
        }
    }

    // sign out по причине истекшего времени жизни рефреша
    func signOutRefreshExpiried() {
        UserDBManager.shared.delete()

        DispatchQueue.main.async {
            AppRouter.shared.switchRoot(type: .signIn)
        }
    }

    func deleteUser() {
        authNetwork.performRequest(type: .deleteUser, expectation: DefaultType.self
        ) { [weak self] _, isSuccess in
            guard let self else { return }

            if isSuccess {
                self.view.showSuccessAlert()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.signOut()
                }
            } else {
                self.view.showFailureAlert()
            }
        }
    }

    @objc
    private func updateSalonStorageAction() {
        updateSavedSaloons()
    }

    @objc
    private func authorizationStatusHasChangedAction(_ notification: NSNotification) {
        if let isAuthorized = notification.userInfo?["isAuthorized"] as? Bool {

            if !isAuthorized {
                signOutRefreshExpiried()
            }
        }
    }

    @objc
    private func updateProfileAction() {
        updateProfile()
    }

    private func subscribeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateSalonStorageAction),
            name: .storageIDidChanged,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(authorizationStatusHasChangedAction(_ :)),
            name: .authorizationStatusHasChanged,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateProfileAction),
            name: .canUpdateProfile,
            object: nil
        )
    }
}
