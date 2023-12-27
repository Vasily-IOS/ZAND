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
    func performRequest(type: AuthRequestType, completion: @escaping (Bool?) -> Void)
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
        provider.request(type) { result in
            switch result {
            case .success(let response):
                let successfulRange = (200...299)
                if let code = response.response?.statusCode {
                    print("Code \(code) and type \(type)")

                    if successfulRange.contains(code) {
                        if let model = self.decoder(
                            data: response.data, expected: expectation
                        ) {
                            completion(model)
                        }
                    } else {
                        print("Error number \(code). Something went wrong")
                    }
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }

    func performRequest(type: AuthRequestType, completion: @escaping (Bool?) -> Void) {
        provider.request(type) { response in
            switch response {
            case .success(let success):
                let successfulRange = (200...299)
                if let responseCode = success.response?.statusCode {
                    if successfulRange.contains(responseCode) {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            case .failure(let error):
                debugPrint(error)
                completion(nil)
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
