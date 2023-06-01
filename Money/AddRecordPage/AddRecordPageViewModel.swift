//
//  AddRecordPageViewModel.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/27.
//

import UIKit

class AddRecordPageViewModel {
    var id: String
    var titleText: String
    var priceTotal: Int
    var date: Date
    var typeID: String
    let isExpense: Int
    
    // 91除, 92乘, 93加, 94減
    var currentOperatorTag = 0
    
    init(id: String = "", titleText: String = "", priceTotal: Int = 0, dateString: String = "", typeID: String = "", isExpense: Int = 1) {
        self.id = id
        self.titleText = titleText
        self.priceTotal = priceTotal

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.date(from: dateString) ?? Date()
        self.typeID = typeID
        self.isExpense = isExpense
    }
}
