//
//  DefaultRealmManager.swift
//  ZAND
//
//  Created by Василий on 07.06.2023.
//

import UIKit
import RealmSwift

final class RealmManagerImpl: RealmManager {
    
    private let defaultRealm: Realm
    
    init() {
        do {
            let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm(configuration: configuration)
            self.defaultRealm = realm
        } catch {
            print(error, error.localizedDescription, "Got Realm Error")
            fatalError()
        }
    }
    
    func save<Element: Object>(object: Element) {
        do {
            try defaultRealm.write {
                defaultRealm.add(object)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func get<Element>(_ type: Element.Type) -> Results<Element> where Element : RealmFetchable {
        return defaultRealm.objects(type)
    }
    
    func removeObject<Element: Object>(object: Element) {
        do {
            try defaultRealm.write({
                defaultRealm.delete(object)
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func removeObjectByID<Element: Object>(object: Element.Type, predicate: NSPredicate) {
        do {
            try defaultRealm.write({
                if let existingObject = defaultRealm.objects(Element.self).filter(predicate).first {
                    defaultRealm.delete(existingObject)
                }
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func contains<Element: Object>(predicate: NSPredicate, _ type: Element.Type) -> Bool {
        let existingObject = defaultRealm.objects(Element.self).filter(predicate).first
        return existingObject == nil
    }

    func removeAll() {
        do {
            try defaultRealm.write({
                defaultRealm.deleteAll()
            })
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func updateProperty(of instance: Object, value: Any, for filed: String) {
        do {
            try defaultRealm.write {
                instance.setValue(value, forKey: filed)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getObject<Element: Object>(
        _ type: Element.Type,
        key: Any) -> Element? {
            return defaultRealm.object(ofType: type, forPrimaryKey: key)
        }
}
