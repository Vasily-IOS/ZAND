//
//  PhotoModel.swift
//  ZAND
//
//  Created by Василий on 25.10.2023.
//

import Foundation
import RealmSwift

class PhotoModel: Object {
    @Persisted var id = Int()
    @Persisted var photos = List<Data>()
}
