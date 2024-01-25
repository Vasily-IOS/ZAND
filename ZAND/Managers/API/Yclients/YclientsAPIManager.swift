//
//  YclientsAPIManager.swift
//  ZAND
//
//  Created by Василий on 10.07.2023.
//

import Foundation
import Moya

protocol YclientsAPI: AnyObject {
    func performRequest<T: Codable>(
        type: YclientsRequestType,
        expectation: T.Type,
        completion: @escaping (T) -> Void
    )
}

final class YclientsAPIManager: YclientsAPI {

    // MARK: - Properties

    private let decoder = JSONDecoder()

    private let provider = MoyaProvider<YclientsRequestType>()

    // MARK: - Instance methods

    func performRequest<T>(
        type: YclientsRequestType,
        expectation: T.Type,
        completion: @escaping (T) -> Void
    ) where T : Decodable, T : Encodable {
        provider.request(type) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let response):
                if let httpResponse = response.response?.statusCode {
                    let successRange = (200...299)
                    if successRange.contains(httpResponse)  {
                        if let model = self.decoder(
                            data: response.data, expected: expectation
                        ) {
                            completion(model)
                        }
                    } else {
                        NotificationCenter.default.post(name: .showBadRequestScreen, object: nil)
                        print("HTTP error number \(httpResponse)")
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
