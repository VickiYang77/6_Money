//
//  updateRecordRequest.swift
//  Money
//
//  Created by Vicki Yang on 2023/6/1.
//

import UIKit

struct updateRecordRequest: Codable {
    let records: [updateRecordModel]
}

struct updateRecordModel: Codable {
    let id: String
    let fields: RecordFieldsModel
}
