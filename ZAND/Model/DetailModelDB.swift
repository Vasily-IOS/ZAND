//
//  DetailModelDB.swift
//  ZAND
//
//  Created by Василий on 03.07.2023.
//

import Foundation
import RealmSwift

class DetailModelDB: Object, CommonModel {
    @Persisted var id = 0
    @Persisted var category: CategoryDB? = CategoryDB()
    @Persisted var saloon_name = ""
    @Persisted var adress = ""
    @Persisted var rating = Data()
    @Persisted var image = Data()
    @Persisted var photos = List<Data>()
    @Persisted var scores = 0
    @Persisted var weekdays = ""
    @Persisted var weekend = ""
    @Persisted var min_price = 0
    @Persisted var descriptions = ""
    @Persisted var coordinates = ""

    func getPhotos() -> List<Data> {
        return photos
    }
}

class CategoryDB: Object {
    @Persisted var id = 0
    @Persisted var name = ""
}
