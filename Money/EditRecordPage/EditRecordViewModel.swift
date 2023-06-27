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
    var record: RecordModel!
    
    @Published var priceTotal: Int
    @Published var type: TypeModel
    
    var recordID: String {
        record.id
    }
    
    var titleText: String {
        record.fields.title
    }
    
    var date: Date {
        record.fields.date
    }
    
    var isExpense: Int {
        record.fields.isExpense
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
}
