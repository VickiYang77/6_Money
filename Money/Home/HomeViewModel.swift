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
    
    var reloadTableView = PassthroughSubject<Void, Never>()
    
    init() {
        setupBinding()
    }
    
    func setupBinding() {
        // 更新section
        $records
            .sink { [weak self] (records) in
                self?.dateSection = Set(records.map(\.fields.date)).sorted(by: >)
            }
            .store(in: &cancellable)
    }
    
    func deleteRecord(_ record: RecordModel) {
        APIService.share.delete(.record, ids: [record.id]) { [weak self] in
            self?.records.removeAll(where: { $0.id == record.id })
        }
    }
    
    func getSectionRecords(_ index: Int) -> [RecordModel] {
        let date = dateSection[index]
        return getRecordsWith(date)
    }
    
    func getRecordsWith(_ date: Date) -> [RecordModel] {
        return records.filter { $0.fields.date == date }
    }
    
    func fetchRecords() {
        APIService.share.fetch(.record) { [weak self] (response: RecordsModel?) in
            guard let self = self, let records = response?.records else { return }
            
            self.records = records.sorted {
                if $0.fields.date == $1.fields.date {
                    return $0.fields.updateTime > $1.fields.updateTime
                } else {
                    return $0.fields.date > $1.fields.date
                }
            }
        }
    }
    
    func fetchTypes() {
        APIService.share.fetch(.type) { [weak self] (response: TypesModel?) in
            guard let self = self, let typesModel = response?.records else { return }
            kAM.share.types = typesModel
            self.reloadTableView.send()
        }
    }
}
