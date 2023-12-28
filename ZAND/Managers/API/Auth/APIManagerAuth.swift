//
//  APIManagerAuth.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

import Foundation
import Moya

protocol APIManagerAuthP: AnyObject {
    func performRequest<T: Codable>(
        type: AuthRequestType,
        expectation: T.Type,
        completion: @escaping (T?, Bool) -> Void
    )
}

final class APIManagerAuth: APIManagerAuthP {

    // MARK: - Properties

    private let decoder = JSONDecoder()
    private let provider = MoyaProvider<AuthRequestType>()

    // MARK: - Instance methods

    func performRequest<T>(
        type: AuthRequestType,
        expectation: T.Type,
        completion: @escaping (T?, Bool) -> Void
    ) where T : Decodable, T : Encodable {
        provider.request(type) { result in
            switch result {
            case .success(let response):
                let successfulRange = (200...299)
                let responseCode = response.response?.statusCode ?? 0

                if successfulRange.contains(responseCode) {
                    if expectation == DefaultType.self {
                        completion(nil, true)
                    } else {
                        if let model = self.decoder(
                            data: response.data, expected: expectation
                        ) {
                            completion(model, true)
                        }
                    }
                } else {
                    completion(nil, false)
                }
            case .failure(let error):
                debugPrint(error)
                completion(nil, false)
            }
        }
    }

    private func decoder<T: Codable>(data: Data, expected: T.Type?) -> T? {
        do {
            if let expected = expected {
                return try self.decoder.decode(expected, from: data)
            } else {
                return nil
            }
        } catch(let error) {
            debugPrint(error)
            return nil
        }
    }
}
