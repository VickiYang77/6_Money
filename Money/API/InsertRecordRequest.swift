//
//  InsertRecordRequest.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/31.
//

import UIKit

struct InsertRecordRequest: Codable {
    let records: [InsertRecordModel]
}

struct InsertRecordModel: Codable {
    let fields: RecordFieldsModel
}
