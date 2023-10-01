//
//  Extansion + UIImage.swift
//  ZAND
//
//  Created by Василий on 04.07.2023.
//

import UIKit

extension UIImage {
    func toData() -> Data? {
        return Data(self.jpegData(compressionQuality: 0.9)!)
    }

    func toData(completion: @escaping ((Data) -> Void)) {
        completion(Data(self.jpegData(compressionQuality: 0.9)!))
    }
}
