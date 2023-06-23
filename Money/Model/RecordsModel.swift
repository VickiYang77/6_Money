//
//  RecordsModel.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/31.
//

import UIKit

struct RecordsModel: Codable {
    let records: [RecordModel]
}

struct RecordModel: Codable {
    let id: String
    let createdTime: String
    let fields: RecordFieldsModel
    
    init(id: String = "", createdTime: String = "", fields: RecordFieldsModel) {
        self.id = id
        self.createdTime = createdTime
        self.fields = fields
    }
}

struct RecordFieldsModel: Codable {
    let title: String
    let price: Int
    let date: String
    let typeID: String
    let isExpense: Int  // Y:支出, N:收入
    let updateTime: String
    
    init(title: String = "", price: Int = 0, date: String = "", typeID: String = "", isExpense: Int = 1) {
        self.title = title
        self.price = price
        self.date = date
        self.typeID = typeID
        self.isExpense = isExpense
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        self.updateTime = dateFormatter.string(from: Date())
    }
}

@available(iOS 13.0, *)
extension RecordModel: Hashable {
    static func == (lhs: RecordModel, rhs: RecordModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
