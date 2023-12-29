//
//  UserDataBaseModel.swift
//  ZAND
//
//  Created by Василий on 29.08.2023.
//

import Foundation
import RealmSwift

class UserDataBaseModel: Object {
    @Persisted var name: String = ""
    @Persisted var surname: String = ""
    @Persisted var fathersName: String = ""
    @Persisted var birthday: String = ""
    @Persisted var phone: String = ""
    @Persisted var email: String = ""
}
