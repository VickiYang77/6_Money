//
//  InsertRequest.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/31.
//

import UIKit

struct InsertRequest<T: Codable>: Codable {
    let records: [T]
}

struct InsertRecordModel: Codable {
    let fields: ApiRecordFieldsModel
}

struct InsertTypeModel: Codable {
    let fields: TypeFieldsModel
}
