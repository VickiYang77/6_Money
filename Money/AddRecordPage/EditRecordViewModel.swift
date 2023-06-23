//
//  EditRecordViewModel.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/27.
//

import UIKit

class EditRecordViewModel {
    var record: RecordModel!
    
    var isEdit: Bool
    
    var recordID: String {
        record.id
    }
    
    var titleText: String {
        record.fields.title
    }
    
    var priceTotal: Int
    
    var date: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: record.fields.date) ?? Date()
    }
    
    var isExpense: Int {
        record.fields.isExpense
    }
    
    var type: TypeModel
    
    // 91除, 92乘, 93加, 94減
    var currentOperatorTag = 0
    
    // MARK: VC binding function
    var reloadData: (() -> ())?
    
    init(_ record: RecordModel = RecordModel(id: "", createdTime: "", fields: RecordFieldsModel()), isEdit: Bool = false) {
        self.record = record
        self.isEdit = isEdit
        self.priceTotal = record.fields.price
        self.type = kAM.share.getTypeWithId(record.fields.typeID)
    }
}
