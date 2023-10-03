//
//  BackgroundRealm.swift
//  ZAND
//
//  Created by Василий on 03.10.2023.
//

import Foundation
import RealmSwift

protocol BackgroundRealm: AnyObject {
    func save<Element: Object>(_ element: Element)
    func remove<Element: Object>(object: Element.Type, predicate: NSPredicate)
    func contains<Element: Object>(predicate: NSPredicate, _ type: Element.Type) -> Bool
}

final class BackgroundRealmImpl {

    // MARK: - Properties

    private let defaultRealm: Realm

    private let queue = DispatchQueue(label: "realm_queue")

    // MARK: - Initializer

    private init() {
        do {
            let configuration = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
            let realm = try Realm(configuration: configuration, queue: queue)
            defaultRealm = realm
        } catch {
            fatalError("Got Realm Error")
        }
    }

    // MARK: - Instance methods

    func save<Element: Object>(_ element: Element) {
        queue.async {
            do {
                try self.defaultRealm.write {
                    self.defaultRealm.add(element)
                }
            } catch {
                debugPrint(error)
            }
        }
    }

    func remove<Element: Object>(object: Element.Type, predicate: NSPredicate) {
        queue.async {
            do {
                try self.defaultRealm.write {
                    if let object = self.defaultRealm.objects(Element.self).filter(predicate).first {
                        self.defaultRealm.delete(object)
                    }
                }
            } catch {
                debugPrint(error)
            }
        }
    }

    func contains<Element: Object>(predicate: NSPredicate, _ type: Element.Type) -> Bool {
        let existingObject = defaultRealm.objects(Element.self).filter(predicate).first
        return existingObject == nil
    }
}
