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
    func checkLogIn()
    func signOut()
}

protocol ProfileViewInput: AnyObject {
    func updateWithLoggedData(model: UserDataBaseModel)
    func updateWithSaloons(model: [Saloon])
}

final class ProfilePresenter: ProfilePresenterOutput {

    // MARK: - Properties

    weak var view: ProfileViewInput?

    private let profileMenuModel = ProfileMenuModel.model

    private var uiModelCount: Int = 0

    private let network: APIManager

    // MARK: - Initializers

    init(view: ProfileViewInput, network: APIManager) {
        self.view = view
        self.network = network

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
            network.performRequest(type: .salons, expectation: Saloons.self) { saloonData in
                let saloon = saloonData.data.first(where: { $0.id == value })
                savedSaloons[index] = saloon
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.view?.updateWithSaloons(model: savedSaloons.compactMap({ $0 }))
        }
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

    @objc
    private func notificationRecieved() {
        updateSavedSaloons()
    }

    private func subscribeNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(notificationRecieved),
            name: .storageIDisChanged,
            object: nil
        )
    }
}
