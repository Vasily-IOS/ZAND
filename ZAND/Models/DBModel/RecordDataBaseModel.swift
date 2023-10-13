//
//  RecordDataBaseModel.swift
//  ZAND
//
//  Created by Василий on 12.10.2023.
//

import Foundation
import RealmSwift

class RecordDataBaseModel: Object {
    @Persisted var id = UUID().uuidString
    @Persisted var company_name: String = ""
    @Persisted var company_address: String = ""
    @Persisted var company_id: String = ""
    @Persisted var record_id: String = ""
}
