//
//  EditRecordViewModel.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/27.
//

import UIKit
import Combine

class EditRecordViewModel {
    let isEdit: Bool
    
    @Published var record: RecordModel
    @Published var priceTotal: Int
    @Published var type: TypeModel
    
    var recordID: String {
        record.id
    }
    
    var titleText: String {
        get {
            record.fields.title
        }
        
        set {
            record.fields.title = newValue
        }
    }
    
    var date: Date {
        get {
            record.fields.date
        }
        
        set {
            record.fields.date = newValue
        }
    }
    
    var isExpense: Int {
        record.fields.isExpense
    }
    
    private var dateString: String {
        DateFormatter.stringyyyyMMdd(from: date) + " 00:00:00"
    }
    
    private var typeID: String {
        type.fields.typeID
    }
    
    // 91除, 92乘, 93加, 94減
    var currentOperatorTag = 0
    
    private var cancellable = Set<AnyCancellable>()
    
    init(_ record: RecordModel = RecordModel(id: "", createdTime: "", fields: RecordFieldsModel()), isEdit: Bool = false) {
        self.record = record
        self.isEdit = isEdit
        self.priceTotal = record.fields.price
        self.type = kAM.share.getTypeWithId(record.fields.typeID)
        setupBinding()
    }
    
    func setupBinding() {
    }
    
    func createApiRecordFieldsModel() -> ApiRecordFieldsModel {
        let title = titleText.count != 0 ? titleText : "title"
        return ApiRecordFieldsModel(title: title, price: priceTotal, date: dateString, typeID: typeID, isExpense: isExpense)
    }
}
