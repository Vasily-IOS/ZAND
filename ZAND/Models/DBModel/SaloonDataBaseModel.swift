//
//  SaloonDataBaseModel.swift
//  ZAND
//
//  Created by Василий on 10.09.2023.
//

import Foundation
import RealmSwift

class SaloonDataBaseModel: Object, SaloonMapModel {
    @Persisted var id: Int = 0
    @Persisted var title: String = ""
    @Persisted var public_title: String = ""
    @Persisted var short_descr: String = ""
    @Persisted var logo: String = ""
    @Persisted var city_id: Int = 0
    @Persisted var city: String = ""
    @Persisted var active: Int = 0
    @Persisted var schedule: String = ""
    @Persisted var address: String = ""
    @Persisted var coordinate_lat: Double = 0.0
    @Persisted var coordinate_lon: Double = 0.0
    @Persisted var descriptionDB: String = ""
    @Persisted var photos = List<Data>()
    @Persisted var company_photos = List<Data>()
    @Persisted var bookforms = List<BookFormDataBase>()
    @Persisted var default_bookform_url: String = ""
}

class BookFormDataBase: Object {
    @Persisted var id: Int = 0
    @Persisted var title: String = ""
    @Persisted var is_default: Int = 0
    @Persisted var url: String = ""
}
