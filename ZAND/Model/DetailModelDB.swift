//
//  DetailModelDB.swift
//  ZAND
//
//  Created by Василий on 03.07.2023.
//

import Foundation
import RealmSwift

final class DetailModelDB: Object {
    @Persisted var id = 0
//    @Persisted var category: Category
    @Persisted var saloon_name = ""

//    @Persisted var adress = ""
//    @Persisted var rating = 0
//    @Persisted var image: UIImage = UIImage()
//    @Persisted var photos: [UIImage] = []
//    @Persisted var scores = 0
//    @Persisted var weekdays = ""
//    @Persisted var weekend = ""
//    @Persisted var min_price = 0
//    @Persisted var descriptions = ""
//    @Persisted var showcase: [Item]
//    @Persisted var coordinates = ""
}


//let id: Int
//let category: Category
//let saloon_name: String
//let adress: String
//let rating: CGFloat
//let image: UIImage
//let photos: [UIImage]
//let scores: Int
//let weekdays: String
//let weekend: String
//let min_price: Int
//let description: String
//let showcase: [Item]
//let coordinates: String


//struct Category: Hashable {
//    let id: Int
//    let name: String
//}
//
//struct Item: Hashable {
//    let image: UIImage?
//    let description: String?
//    let price_from: Int?
//}
