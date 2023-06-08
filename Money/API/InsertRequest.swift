//
//  InsertRequest.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/31.
//

import UIKit

// MARK: - Record Request
struct InsertRecordRequest: Codable {
    let records: [InsertRecordModel]
}

struct InsertRecordModel: Codable {
    let fields: RecordFieldsModel
}


// MARK: - Type Request
struct InsertTypeRequest: Codable {
    let records: [InsertTypeModel]
}

struct InsertTypeModel: Codable {
    let fields: TypeFieldsModel
}
