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
    func deleteProfile()
}

protocol ProfileViewInput: AnyObject {
    func updateProfile(model: UserDataBaseModel)
    func updateWithSaloons(model: [Saloon])
}

final class ProfilePresenter: ProfilePresenterOutput {

    // MARK: - Properties

    weak var view: ProfileViewInput?

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
            self.view?.updateWithSaloons(model: savedSaloons.compactMap({ $0 }))
        }
    }

    func updateProfile() {
        if let user = UserDBManager.shared.get() {
            view?.updateProfile(model: user)
        }
    }

    func signOut() {
        UserDBManager.shared.delete()
        TokenManager.shared.deleteToken()
        AppRouter.shared.switchRoot(type: .signIn)
    }

    func deleteProfile() {
        authNetwork.performRequest(type: .deleteUser) { [weak self] isSuccess in
            if isSuccess == true {
                self?.signOut()
            } else {
                print("Юзер не был удален")
            }
        }
    }

    @objc
    private func notificationRecieved() {
        updateSavedSaloons()
    }

    private func subscribeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationRecieved),
            name: .storageIDidChanged,
            object: nil
        )
    }
}
