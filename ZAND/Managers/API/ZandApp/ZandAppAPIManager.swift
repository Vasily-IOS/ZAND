//
//  ZandAppAPIManager.swift
//  ZAND
//
//  Created by Василий on 25.12.2023.
//

import Foundation
import Moya

protocol ZandAppAPI: AnyObject {
    func performRequest<T: Codable>(
        type: ZandAppRequestType,
        expectation: T.Type,
        completion: @escaping (T?, Bool) -> Void,
        error: @escaping ((Data) -> Void)
    )
}

final class ZandAppAPIManager: ZandAppAPI {

    // MARK: - Properties

    private let decoder = JSONDecoder()
    
    private let provider = MoyaProvider<ZandAppRequestType>()

    // MARK: - Instance methods

    func performRequest<T>(
        type: ZandAppRequestType,
        expectation: T.Type,
        completion: @escaping (T?, Bool) -> Void,
        error: @escaping ((Data) -> Void)
    ) where T : Decodable, T : Encodable {
        provider.request(type) { [weak self] result in
            guard let self else { return }

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
                    error(response.data)
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
