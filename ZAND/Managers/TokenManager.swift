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

        let accessLifeTime = 250
        if refreshExpiried(date: tokenModel.savedDate) {
            deleteToken()
            print("Refresh invalid. Delete and log out")
        } else if accessIsValid(date: tokenModel.savedDate, expiriesIn: accessLifeTime) {
            updateToken()
            print("Update token")
        }
    }

    func deleteToken() {
        keyChain.delete(Config.token)
    }

    // MARK: - Private methods

    private func accessIsValid(date: Date, expiriesIn: Int) -> Bool {
        let now = Date()
        let seconds = TimeInterval(expiriesIn)
        return now.timeIntervalSince(date) > seconds
    }

    private func refreshExpiried(date: Date) -> Bool {
        let now = Date()
        let seconds = TimeInterval(550)
        return now.timeIntervalSince(date) > seconds
    }

    private func updateToken() {
        guard let tokenModel = getSavedTokenModel() else { return }

        apiManager.performRequest(
            type: .refreshToken(RefreshTokenModel(refreshToken: tokenModel.refreshToken)),
            expectation: UpdatedTokenModel.self
        ) { [weak self] updatedModel in

            let model = TokenModel(
                accessToken: updatedModel.data.token,
                refreshToken: updatedModel.data.refreshToken,
                savedDate: Date()
            )
            self?.save(model)
        }
    }
}
