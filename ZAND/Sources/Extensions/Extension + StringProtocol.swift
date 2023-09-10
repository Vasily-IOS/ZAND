//
//  Extension + StringProtocol.swift
//  ZAND
//
//  Created by Василий on 04.07.2023.
//

import Foundation

extension String {
    func imageToData(completion: @escaping (Data?) -> ()) {
        guard let url = URL(string: self) else {
            completion(nil)
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let data = data, error == nil {
                completion(data)
            }
        }.resume()
    }
}
