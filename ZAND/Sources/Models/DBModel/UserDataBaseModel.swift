//
//  UserModelDB.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import Foundation
import RealmSwift
import Realm

class UserDataBaseModel: Object {
    @Persisted var id: String = ""
    @Persisted var givenName: String = ""
    @Persisted var familyName: String = ""
    @Persisted var email: String = ""
    @Persisted var phone: String = ""
}
