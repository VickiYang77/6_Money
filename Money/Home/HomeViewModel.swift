//
//  HomeViewModel.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/15.
//

import UIKit

class HomeViewModel {
    var dateSection: [String] = []
    var recordsDic: [String: [RecordModel]] = [:]
    var budget: Int = 100
    var expense: Int = 30
    
    // MARK: VC binding function
    var reloadData: (() -> ())?
    
    func fetchRecords() {
        APIService.share.fetchRecords(completion: { [weak self] recordsModel in
            guard let self = self else { return }
            
            self.recordsDic = [:] // reset
            
            recordsModel.forEach { record in
                if self.recordsDic[record.fields.date] == nil {
                    self.recordsDic[record.fields.date] = []
                }
                self.recordsDic[record.fields.date]?.append(record)
            }
            
            self.dateSection = self.recordsDic.keys.sorted(by: >)
            
            self.reloadData?()
        })
    }
}
