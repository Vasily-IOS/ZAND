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

    var bearerToken: String {
        return keyChain.get(Config.token) ?? ""
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

    func save(token: TokenModel) {
        do {
            let data = try JSONEncoder().encode(token)
            keyChain.set(data, forKey: Config.token)
        } catch let error {
            print(error.localizedDescription)
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

        let accessLifeTime = 300 // 5 минут
        if accessIsValid(date: tokenModel.savedDate, expiriesIn: accessLifeTime) {
            updateToken()
            print("Update token")
        } else if refreshIsValid(date: tokenModel.savedDate) {
            delete()
            print("Refresh invalid. Delete ang log out")
        }
    }

    func delete() {
        keyChain.delete(Config.token)
    }


    // MARK: - Private methods

    private func accessIsValid(date: Date, expiriesIn: Int) -> Bool {
        let now = Date()
        let seconds = TimeInterval(expiriesIn)
        return now.timeIntervalSince(date) > seconds
    }

    private func refreshIsValid(date: Date) -> Bool {
        let now = Date()
        let seconds = TimeInterval(10000)
        return now.timeIntervalSince(date) > seconds
    }

    private func updateToken() {
        guard let tokenModel = getSavedTokenModel() else { return }

        apiManager.performRequest(
            type: .refreshToken(tokenModel.refreshToken),
            expectation: UpdatedTokenModel.self
        ) { [weak self] updatedModel in

            let model = TokenModel(
                accessToken: updatedModel.data.token,
                refreshToken: updatedModel.data.refreshToken,
                savedDate: Date()
            )
            self?.save(token: model)
        }
    }
}
