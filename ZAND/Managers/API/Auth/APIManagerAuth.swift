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
        completion: @escaping (T) -> Void
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
        completion: @escaping (T) -> Void
    ) where T : Decodable, T : Encodable {
        provider.request(type) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let response):


                if let code = response.response?.statusCode {
                    print("Code \(code) and type \(type)")
//                    let successRange = (200...299)
                    if let model = self.decoder(
                        data: response.data, expected: expectation
                    ) {
                        completion(model)
                    }
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }

    private func decoder<T: Codable>(data: Data, expected: T.Type) -> T? {
        do {
            let json = try self.decoder.decode(
                expected,
                from: data
            )
            return json
        } catch(let error) {
            debugPrint(error)
            return nil
        }
    }
}
