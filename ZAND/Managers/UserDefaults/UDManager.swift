//
//  UDManager.swift
//  ZAND
//
//  Created by Василий on 22.07.2023.
//

import Foundation

protocol UDManagerImpl {
    func save<T: Codable>(_ element: T, _ key: String)
    func loadElement<T: Codable>(to: T.Type,_ key: String) -> T?
    func deleteElement(by key: String)
}

final class UDManager: UDManagerImpl {

    let decoder = JSONDecoder()
    let encoder = JSONEncoder()

    // MARK: - Instance methods

    func save<T: Codable>(_ element: T, _ key: String) {
        if let data = try? encoder.encode(element) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func loadElement<T: Codable>(to: T.Type,_ key: String) -> T? {
        if let data = UserDefaults.standard.data(forKey: key),
           let element = try? decoder.decode(T.self, from: data) {
           return element
        } else {
            return nil
        }
    }

    func deleteElement(by key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
