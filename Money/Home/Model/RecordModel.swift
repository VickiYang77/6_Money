//
//  RecordModel.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/28.
//

import UIKit

struct RecordsResponse: Codable {
    let records: [RecordApiModel]
}

// Airtable API Model
struct RecordApiModel: Codable {
    let id: String
    let createdTime: String
    let fields: RecordModel
}

struct RecordModel: Codable {
    let id: String
    let isExpense: Int  // Y:支出, N:收入
    let date: String
    let price: Int
    let typeID: [String]
    let typeName: [String]
    let memo: String
    let createdTime: String
}

