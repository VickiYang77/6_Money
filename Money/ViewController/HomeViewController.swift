//
//  HomeViewController.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/13.
//

import UIKit

struct SectionData {
    var date: String
    
    lazy var total: Int = {
        return self.recordDatas.reduce(0) { $0 + $1.price }
    }()
    
    var recordDatas: [RecordData]
    
    // 是否收合
    var isOpen: Bool
}

struct RecordData {
    var date: String
    var type: costType
    var title: String
    var price: Int
}

class HomeViewController: UIViewController {
    
    @IBOutlet weak var graphView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var tableViewData: [SectionData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        graphView.backgroundColor = .orange
        
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
        
        tableViewData = [
            SectionData(date: "2023/05/01", recordDatas: [
                RecordData(date: "2023/05/01", type: .breakfast, title: "早餐", price: 80),
                RecordData(date: "2023/05/01", type: .lunch, title: "午餐", price: 120),
                RecordData(date: "2023/05/01", type: .dailyNecessities, title: "全聯", price: 2500),
                RecordData(date: "2023/05/01", type: .shopping, title: "衣服", price: 880),
                RecordData(date: "2023/05/01", type: .none, title: "其他", price: 150)
            ], isOpen: true),
            SectionData(date: "2023/05/09", recordDatas: [
                RecordData(date: "2023/05/09", type: .shopping, title: "網購", price: 1250)
            ], isOpen: true),
            SectionData(date: "2023/05/12", recordDatas: [
                RecordData(date: "2023/05/09", type: .transportation, title: "火車", price: 1250)
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
        
        setupUI()
    }
    
    func setupUI() {
        navigationItem.title = "Money Note"
        navigationController?.navigationBar.addBottomSeparator()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecordSectionView.nib(), forHeaderFooterViewReuseIdentifier: RecordSectionView.identifier)
        tableView.register(RecordTableViewCell.nib(), forCellReuseIdentifier: RecordTableViewCell.identifier)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].isOpen {
            return tableViewData[section].recordDatas.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecordSectionView.identifier) as! RecordSectionView
        guard tableViewData.count > section else { return UITableViewHeaderFooterView() }
        
        sectionView.setupUI(date: tableViewData[section].date, total: "\(section+10)")
        
        // set backgroundColor
        let sectionColorView = UIView()
        sectionColorView.backgroundColor = ColorHepler.homeSectionColor
        sectionView.backgroundView = sectionColorView
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier, for: indexPath) as! RecordTableViewCell
        guard tableViewData[indexPath.section].recordDatas.count > indexPath.row else { return UITableViewCell() }
        
        let cellData = tableViewData[indexPath.section].recordDatas[indexPath.row]
        cell.setupUI(type: cellData.type, title: cellData.title, price: "\(cellData.price)")
        cell.backgroundColor = ColorHepler.listSelectedColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
