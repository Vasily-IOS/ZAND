//
//  SaloonProvider.swift
//  ZAND
//
//  Created by Василий on 06.09.2023.
//

import Foundation

protocol SaloonProvider: AnyObject {
    func fetchData(completion: @escaping ([Saloon]) -> Void)
}

final class SaloonProviderImpl: SaloonProvider {

    // MARK: - Properties

    private let apiManager: APIManager = APIManagerImpl()

    // MARK: - Instance methods

    func fetchData(completion: @escaping ([Saloon]) -> Void) {
        apiManager.performRequest(type: .salons, expectation: Saloons.self)
        { result in
            if !result.data.isEmpty {
                completion(result.data)
            } else {
                print("We have no salons")
            }
        }
    }
}
