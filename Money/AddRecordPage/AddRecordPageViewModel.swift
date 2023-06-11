//
//  AddRecordPageViewModel.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/27.
//

import UIKit

class AddRecordPageViewModel {
    var recordID: String
    var titleText: String
    var priceTotal: Int
    var date: Date
    let isExpense: Int
    var type: TypeModel
    
    // 91除, 92乘, 93加, 94減
    var currentOperatorTag = 0
    
    // MARK: VC binding function
    var reloadData: (() -> ())?
    
    init(recordID: String = "", titleText: String = "", priceTotal: Int = 0, dateString: String = "", typeID: String = "", isExpense: Int = 1) {
        self.recordID = recordID
        self.titleText = titleText
        self.priceTotal = priceTotal

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        self.date = dateFormatter.date(from: dateString) ?? Date()
        self.isExpense = isExpense
        
        self.type = kAM.share.getTypeWithId(typeID)
    }
}
