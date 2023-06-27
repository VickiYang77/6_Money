//
//  HomeViewModel.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/15.
//

import UIKit
import Combine

class HomeViewModel {
    @Published var dateSection: [Date] = []
    @Published var records: [RecordModel] = []
    @Published var budget: Int = 5000
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
                    
                    self.dateSection = Set(recordsModel.map(\.fields.date)).sorted(by: >)
                    self.records = recordsModel.sorted {
                        if $0.fields.date == $1.fields.date {
                            return $0.fields.updateTime > $1.fields.updateTime
                        } else {
                            return $0.fields.date > $1.fields.date
                        }
                    }
                })
            }
            .store(in: &cancellable)
    }
    
    func getSectionRecords(_ index: Int) -> [RecordModel] {
        let date = dateSection[index]
        return getRecordsWith(date)
    }
    
    func getRecordsWith(_ date: Date) -> [RecordModel] {
        return records.filter { $0.fields.date == date }
    }
}
