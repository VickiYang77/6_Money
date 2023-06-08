//
//  AddRecordPageViewModel.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/27.
//

import UIKit

class AddRecordPageViewModel {
    var types: [TypeModel] = []
    var recordID: String
    var titleText: String
    var priceTotal: Int
    var date: Date
    var typeID: String
    let isExpense: Int
    
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
        self.typeID = typeID
        self.isExpense = isExpense
    }
    
    func fetchTypes() {
        APIService.share.fetchTypes(completion: { [weak self] typesModel in
            guard let self = self else { return }
            self.types = typesModel
            self.reloadData?()
        })
    }
}
