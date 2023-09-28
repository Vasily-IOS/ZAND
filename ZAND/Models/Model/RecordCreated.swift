//
//  RecordCreated.swift
//  ZAND
//
//  Created by Василий on 28.09.2023.
//

import Foundation

struct RecordCreatedModel: Codable {
    let success: Bool
    let data: [RecordModel]
}

struct RecordModel: Codable {
    let id: Int
    let record_id: Int
    let record_hash: String
}
