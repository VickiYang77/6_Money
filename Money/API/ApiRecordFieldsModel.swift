//
//  ApiRecordFieldsModel.swift
//  Money
//
//  Created by 金融研發一部-楊雅婷 on 2023/6/26.
//

import UIKit

struct ApiRecordFieldsModel: Codable {
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
        self.updateTime = DateFormatter.stringyyyyMMddAndTime(from: Date())
    }
}
