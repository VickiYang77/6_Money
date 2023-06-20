//
//  HomeViewModel.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/15.
//

import UIKit
import Combine

class HomeViewModel {
    @Published var dateSection: [String] = []
    @Published var recordsDic: [String: [RecordModel]] = [:]
    @Published var budget: Int = 3000    // 預算
    @Published var expense: Int = 0    // 支出
    private var cancellable = Set<AnyCancellable>()
    
    var fetchRecords = PassthroughSubject<Void, Never>()
    
    init() {
        setupBinding()
    }
    
    func setupBinding() {
        fetchRecords
            .sink {
                APIService.share.fetchRecords(completion: { [weak self] recordsModel in
                    guard let self = self else { return }
                    
                    var recordsDic = [String: [RecordModel]]()
                    var expense = 0
                    
                    recordsModel.forEach { record in
                        if recordsDic[record.fields.date] == nil {
                            recordsDic[record.fields.date] = []
                        }
                        recordsDic[record.fields.date]?.append(record)
                        expense += record.fields.price
                    }
                    
                    self.dateSection = recordsDic.keys.sorted(by: >)
                    self.recordsDic = recordsDic
                    self.expense = expense
                })
            }
            .store(in: &cancellable)
    }
}
