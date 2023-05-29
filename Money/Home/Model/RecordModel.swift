//
//  RecordModel.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/28.
//

import UIKit

struct RecordModel: Codable {
    let id: String
    let title: String
    let price: Int
    let date: String
    let typeId: String?
    let isExpense: Int  // Y:支出, N:收入
    let createdTime: String
    
    init(title: String = "", price: Int, date: String, typeId: String = "", isExpense: Int) {
        self.id = UUID().uuidString
        self.title = title
        self.price = price
        self.date = date
        self.typeId = typeId
        self.isExpense = isExpense
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        self.createdTime = dateFormatter.string(from: Date())
    }
}

struct FetchRecordResponse: Codable {
    let records: [RecordBody]
    
    struct RecordBody: Codable {
        let id: String
        let createdTime: String
        let fields: RecordModel
    }
}

struct InsetRecordRequest: Codable {
    let records: [RecordBody]
    
    struct RecordBody: Codable {
        let fields: RecordModel
    }
    
    struct FieldsModel: Codable {
        let title: String
        let price: Int
        let date: String
        let typeId: String
        let isExpense: Int
    }
}


