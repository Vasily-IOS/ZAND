//
//  SaloonProvider.swift
//  ZAND
//
//  Created by Василий on 06.09.2023.
//

import CoreLocation
import UIKit

protocol SaloonProvider: AnyObject {
    func fetchData(completion: @escaping ([Saloon]) -> Void)
}

final class SaloonProviderImpl: SaloonProvider {

    // MARK: - Properties

    private let apiManager: APIManager = APIManagerImpl()

    // MARK: - Instance methods

    func fetchData(completion: @escaping ([Saloon]) -> Void) {
        apiManager.performRequest(type: .salons, expectation: SalonsCodableModel.self
        ) { result in
            if !result.data.isEmpty {
                let result = result.data.map{ SaloonModel(saloonCodable: $0) }
                completion(result)
            } else {
                print("We have no salons")
            }
        }
    }
}
