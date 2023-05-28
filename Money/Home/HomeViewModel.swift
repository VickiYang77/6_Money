//
//  HomeViewModel.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/15.
//

import UIKit

class HomeViewModel {
    var apiService = RecordAPIService()
    var dateSection: [String] = []
    var records: [String: [RecordModel]] = [:]
    
    // MARK: VC binding function
    var reloadData: (() -> ())?
    
    init() {
    }
    
    func fetchRecords() {
        apiService.fetchRecords(completion: { [weak self] result in
            guard let self = self else { return }
            self.records = Dictionary(grouping: result) {
                $0.date
            }
            
            self.dateSection = self.records.keys.sorted(by: >)
            
            self.reloadData?()
        })
    }
}
