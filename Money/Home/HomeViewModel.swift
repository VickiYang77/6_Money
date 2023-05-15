//
//  HomeViewModel.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/15.
//

import UIKit

class HomeViewModel {
    var recordDatas: [SectionData] = []
    
    init() {
        recordDatas = [
            SectionData(date: "2023/05/01", recordDatas: [
                RecordData(date: "2023/05/01", type: .breakfast, title: "早餐", price: 80),
                RecordData(date: "2023/05/01", type: .lunch, title: "午餐", price: 120),
                RecordData(date: "2023/05/01", type: .dailyNecessities, title: "全聯", price: 2500),
                RecordData(date: "2023/05/01", type: .shopping, title: "衣服", price: 880),
                RecordData(date: "2023/05/01", type: .none, title: "其他", price: 150)
            ], isOpen: true),
            SectionData(date: "2023/05/09", recordDatas: [
                RecordData(date: "2023/05/09", type: .shopping, title: "網購", price: 2330)
            ], isOpen: true),
            SectionData(date: "2023/05/12", recordDatas: [
                RecordData(date: "2023/05/09", type: .transportation, title: "火車", price: 120)
            ], isOpen: true),
            SectionData(date: "2023/05/15", recordDatas: [
                RecordData(date: "2023/05/15", type: .drinks, title: "飲料", price: 80),
                RecordData(date: "2023/05/15", type: .dessert, title: "下午茶", price: 200)
            ], isOpen: true),
            SectionData(date: "2023/05/16", recordDatas: [
                RecordData(date: "2023/05/16", type: .gift, title: "禮物", price: 60),
                RecordData(date: "2023/05/16", type: .dailyNecessities, title: "衛生紙", price: 199)
            ], isOpen: true)
        ]
    }
    
    //        var booksDic = [String: [RecordData]]()
    //        let books = [
    //            RecordData(date: "2023/05/01", type: .breakfast, title: "早餐", price: 80),
    //            RecordData(date: "2023/05/01", type: .lunch, title: "午餐", price: 120),
    //            RecordData(date: "2023/05/01", type: .dailyNecessities, title: "全聯", price: 2500),
    //            RecordData(date: "2023/05/01", type: .shopping, title: "衣服", price: 880),
    //            RecordData(date: "2023/05/01", type: .dinner, title: "晚餐", price: 150),
    //            RecordData(date: "2023/05/09", type: .shopping, title: "網購", price: 1250),
    //            RecordData(date: "2023/05/15", type: .drinks, title: "飲料", price: 80),
    //            RecordData(date: "2023/05/15", type: .dessert, title: "下午茶", price: 200)
    //        ]
    //        booksDic = Dictionary(grouping: books, by: { book in
    //            book.date
    //        })
}
