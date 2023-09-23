//
//  SaloonMockModel.swift
//  ZAND
//
//  Created by Василий on 18.04.2023.
//

import UIKit

//struct SaloonMockModel: CommonModel, CommonFilterProtocol, Hashable {
//    let id: Int
//    let category: Category
//    let saloon_name: String
//    let adress: String
//    let rating: CGFloat
//    let image: UIImage
//    let photos: [UIImage]
//    let scores: Int
//    let weekdays: String
//    let weekend: String
//    let min_price: Int
//    let description: String
//    let showcase: [Item]
//    let coordinates: String
//
//    static let saloons: [Self] = [
//        .init(id: 0, category: Category(id: 0, name: "спа-салон"),
//              saloon_name: "Beautiful eyes",
//              adress: "Колпачный переулок, д. 6, стр. 4",
//              rating: 5.0,
//              image: UIImage(named: "1")!,
//              photos: [
//                UIImage(named: "1")!,
//                UIImage(named: "1.1")!,
//                UIImage(named: "1.2")!,
//                UIImage(named: "1.3")!
//              ],
//              scores: 125,
//              weekdays: "c 9:00 до 23:00",
//              weekend: "c 10:00 до 22:00",
//              min_price: 400,
//              description: "Салон, расположенный в самом сердце столицы, в котором предоставляют первоклассное обслуживание для своих посетителей. Здесь вас ждет большой выбор процедур для сохранения красоты волос и тела. Мастера помогут вам снова засиять от счастья.",
//              showcase: [
//                Item(image: nil,
//                     description: nil,
//                     price_from: nil)],
//              coordinates: "55.933301,37.514214"),
//        
//            .init(id: 1, category: Category(id: 0, name: "спа-салон"),
//                  saloon_name: "Good smiles",
//                  adress: "Юбилейный проспект, д. 7",
//                  rating: 4.6,
//                  image: UIImage(named: "2")!,
//                  photos: [
//                    UIImage(named: "2")!,
//                    UIImage(named: "2.1")!,
//                    UIImage(named: "2.2")!,
//                    UIImage(named: "2.3")!],
//                  scores: 900,
//                  weekdays: "c 9:00 до 23:00",
//                  weekend: "c 10:00 до 22:00",
//                  min_price: 500,
//                  description: "Салон, расположенный в самом сердце столицы, в котором предоставляют первоклассное обслуживание для своих посетителей. Здесь вас ждет большой выбор процедур для сохранения красоты волос и тела. Мастера помогут вам снова засиять от счастья.",
//                  showcase: [
//                    Item(image: nil,
//                         description: nil,
//                         price_from: nil)],
//                  coordinates: "55.763908,37.60646"),
//        .init(id: 2, category: Category(id: 1, name: "салон красоты"),
//              saloon_name: "Wella krasavella",
//              adress: "ул. Союзная, д. 6, стр. 3",
//              rating: 3.0,
//              image: UIImage(named: "3")!,
//              photos: [
//                UIImage(named: "3")!,
//                UIImage(named: "3.1")!,
//                UIImage(named: "3.2")!,
//                UIImage(named: "3.3")!],
//              scores: 1,
//              weekdays: "c 9:00 до 23:00",
//              weekend: "c 10:00 до 22:00",
//              min_price: 600,
//              description: "Салон, расположенный в самом сердце столицы, в котором предоставляют первоклассное обслуживание для своих посетителей. Здесь вас ждет большой выбор процедур для сохранения красоты волос и тела. Мастера помогут вам снова засиять от счастья.",
//              showcase: [
//                Item(image: nil,
//                     description: nil,
//                     price_from: nil)],
//              coordinates: "55.583205,37.59674"),
//        .init(id: 3, category: Category(id: 1, name: "салон красоты"),
//              saloon_name: "Приукрасим так приукрасим",
//              adress: "Переулок Твардовского, д. 4",
//              rating: 4.1,
//              image: UIImage(named: "5")!,
//              photos: [
//                UIImage(named: "5")!,
//                UIImage(named: "4.1")!,
//                UIImage(named: "4.2")!,
//                UIImage(named: "4.3")!],
//              scores: 750,
//              weekdays: "c 9:00 до 23:00",
//              weekend: "c 10:00 до 22:00",
//              min_price: 350,
//              description: "Салон, расположенный в самом сердце столицы, в котором предоставляют первоклассное обслуживание для своих посетителей. Здесь вас ждет большой выбор процедур для сохранения красоты волос и тела. Мастера помогут вам снова засиять от счастья.",
//              showcase: [
//                Item(image: nil,
//                     description: nil,
//                     price_from: nil)],
//              coordinates: "55.751665,37.817169"),
//        .init(id: 4, category: Category(id: 2, name: "массажный салон"),
//              saloon_name: "Good Relaх",
//              adress: "1-ая Тверская-Ямская, д. 1, стр. 7",
//              rating: 4.2,
//              image: UIImage(named: "6")!,
//              photos: [
//                UIImage(named: "6")!,
//                UIImage(named: "5.1")!,
//                UIImage(named: "5.2")!,
//                UIImage(named: "5.3")!],
//              scores: 250,
//              weekdays: "c 9:00 до 23:00",
//              weekend: "c 10:00 до 22:00",
//              min_price: 550,
//              description: "Салон, расположенный в самом сердце столицы, в котором предоставляют первоклассное обслуживание для своих посетителей. Здесь вас ждет большой выбор процедур для сохранения красоты волос и тела. Мастера помогут вам снова засиять от счастья.",
//              showcase: [
//                Item(image: nil,
//                     description: nil,
//                     price_from: nil)],
//              coordinates: "55.756842,37.408139"),
//    ]
//}

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
