//
//  updateRequest.swift
//  Money
//
//  Created by Vicki Yang on 2023/6/1.
//

import UIKit


struct updateRequest<T: Codable>: Codable {
    let records: [T]
}

struct updateRecordModel: Codable {
    let id: String
    let fields: ApiRecordFieldsModel
}

struct updateTypeModel: Codable {
    let id: String
    let fields: TypeFieldsModel
}
