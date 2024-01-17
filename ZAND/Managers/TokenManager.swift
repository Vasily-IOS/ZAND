//
//  TokenManager.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

import Foundation
import KeychainSwift

final class TokenManager {

    // MARK: - Nested types

    enum TokenType {
        case access
        case refresh
    }

    // MARK: - Properties

    static let shared = TokenManager()

    var bearerToken: String? {
        return getSavedTokenModel()?.accessToken
    }

    var appDelegate: AppDelegate? {
        didSet {
            checkAuthorization()
        }
    }

    private let apiManager: APIManagerAuthP = APIManagerAuth()

    private let keyChain = KeychainSwift()

    // MARK: - Initializers

    private init() {}

    // MARK: - Public methods

    func save(_ token: TokenModel) {
        do {
            let data = try JSONEncoder().encode(token)
            keyChain.set(data, forKey: Config.token)
        } catch let error {
            debugPrint(error)
        }
    }

    func getSavedTokenModel() -> TokenModel? {
        do {
            let data = keyChain.getData(Config.token)
            let model = try JSONDecoder().decode(TokenModel.self, from: data ?? Data())
            return model
        } catch {
            return nil
        }
    }

    func checkAuthorization() {
        guard let tokenModel = getSavedTokenModel() else { return }

        if refreshExpiried(savedDate: tokenModel.savedDate) {
            delete()
            sendNotification()
            print("Refresh expiried. Log out.")
        } else if accessExpiried(savedDate: tokenModel.savedDate) {
            updateToken()
            print("Access expiried. Refresh.")
        }
    }

    func delete() {
        keyChain.delete(Config.token)
    }

    // MARK: - Private methods

    private func accessExpiried(savedDate: Date) -> Bool {
        let accessLifeTime = TimeInterval(1800) // 30 min

        return Date().timeIntervalSince(savedDate) >= (accessLifeTime - 10)
    }

    private func refreshExpiried(savedDate: Date) -> Bool {
        let refreshLifeTime = TimeInterval(86400) // 24 hours

        return Date().timeIntervalSince(savedDate) >= (refreshLifeTime - 10)
    }

    private func updateToken() {
        guard let tokenModel = getSavedTokenModel() else { return }

        apiManager.performRequest(
            type: .refreshToken(RefreshTokenModel(refreshToken: tokenModel.refreshToken)),
            expectation: UpdatedTokenModel.self
        ) { [weak self] updatedModel, isSuccess in

            guard let updatedModel = updatedModel, isSuccess else { return }

            let model = TokenModel(
                accessToken: updatedModel.data.token,
                refreshToken: updatedModel.data.refreshToken,
                savedDate: Date()
            )
            self?.save(model)
        }
    }

    private func sendNotification() {
        let userInfo = ["isAuthorized": false]
        NotificationCenter.default.post(
            name: .authorizationStatusHasChanged,
            object: nil,
            userInfo: userInfo
        )
    }
}
