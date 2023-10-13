//
//  UserModelDB.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import Foundation
import RealmSwift

class Test: Object {
    @Persisted var data = List<UserTest>()
}

class UserTest: Object {
    @Persisted var id: String = "" // apple ID
    @Persisted var user = UserDataBaseModel()
}

class UserDataBaseModel: Object {
    @Persisted var id: String = ""
    @Persisted var givenName: String = ""
    @Persisted var familyName: String = ""
    @Persisted var email: String = ""
    @Persisted var phone: String = ""
    @Persisted var records = List<RecordDataBaseModel>()
}
