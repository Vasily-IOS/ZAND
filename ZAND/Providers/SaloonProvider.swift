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

    private let network: ZandAppAPI = ZandAppAPIManager()

    // MARK: - Instance methods

    func fetchData(completion: @escaping ([Saloon]) -> Void) {
        network.performRequest(type: .salons(size: 100), expectation: SalonsCodableModel.self
        ) { result, isSuccess  in
            guard isSuccess else { return }

            if let model = result?.data {
                let result = model.map { SaloonModel(saloonCodable: $0) }
                completion(result)
            }
        } error: { _ in }
    }
}
