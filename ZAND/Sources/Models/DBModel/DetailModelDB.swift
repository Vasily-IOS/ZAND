//
//  DetailModelDB.swift
//  ZAND
//
//  Created by Василий on 03.07.2023.
//

import Foundation
import RealmSwift

class DetailModelDB: Object, SaloonMapModel {
    @Persisted var id = 0
    @Persisted var title: String = ""
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
    @Persisted var coordinate_lat: Double = 0
    @Persisted var coordinate_lon: Double = 0

    func getPhotos() -> List<Data> {
        return photos
    }
}

class CategoryDB: Object {
    @Persisted var id = 0
    @Persisted var name = ""
}
