//
//  HTTP.swift
//  ZAND
//
//  Created by Василий on 10.07.2023.
//

import Foundation

protocol HTTP: AnyObject {
    func performRequest<T: Codable>(
        type: RequestType,
        expectation: T.Type,
        completion: @escaping (T) -> Void
    )
}
