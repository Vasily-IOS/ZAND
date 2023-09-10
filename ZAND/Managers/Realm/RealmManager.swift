//
//  RealmManager.swift
//  ZAND
//
//  Created by Василий on 07.06.2023.
//

import UIKit
import RealmSwift

protocol RealmManager {
    func save<Element: Object>(object: Element)
    func get<Element>(_ type: Element.Type) -> Results<Element> where Element: RealmFetchable
    func removeObject<Element: Object>(object: Element)
    func removeObjectByID<Element: Object>(object: Element.Type, predicate: NSPredicate)
    func updateProperty(of instance: Object, value: Any, for filed: String)
    func removeAll()
    func getObject<Element: Object>(_ type: Element.Type, key: Any) -> Element?
    func contains<Element: Object>(predicate: NSPredicate, _ type: Element.Type) -> Bool
}
