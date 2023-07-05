//
//  Extension + CGFloat.swift
//  ZAND
//
//  Created by Василий on 04.07.2023.
//

import UIKit

extension CGFloat {

    init(data: Data) {
        self.init()
        do {
            self = try JSONDecoder().decode(Self.self, from: data)
        } catch let error {
            print("Failed to convert CGFloat from Data, error: \(error)")
        }
    }

    func toData() -> Data? {
        do {
            return try JSONEncoder().encode(self)
        } catch let error {
            print("Failed to convert CGFloat to Data, error: \(error)")
            return nil
        }
    }
}
