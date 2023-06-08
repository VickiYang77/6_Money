//
//  updateRequest.swift
//  Money
//
//  Created by Vicki Yang on 2023/6/1.
//

import UIKit

// MARK: - Record Request
struct updateRecordRequest: Codable {
    let records: [updateRecordModel]
}

struct updateRecordModel: Codable {
    let id: String
    let fields: RecordFieldsModel
}


// MARK: - Type Request
struct updateTypeRequest: Codable {
    let records: [updateTypeModel]
}

struct updateTypeModel: Codable {
    let id: String
    let fields: TypeFieldsModel
}
