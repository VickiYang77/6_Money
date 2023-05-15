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
    
    var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        return viewModel.recordDatas.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.recordDatas[section].isOpen {
            return viewModel.recordDatas[section].recordDatas.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecordSectionView.identifier) as! RecordSectionView
        guard viewModel.recordDatas.count > section else { return UITableViewHeaderFooterView() }
        
        let sectionData = viewModel.recordDatas[section]
        let sectionTotal = sectionData.recordDatas.reduce(0, { $0 + $1.price})
        sectionView.setupUI(date: sectionData.date, total: "\(sectionTotal)")
        
        // set backgroundColor
        let sectionColorView = UIView()
        sectionColorView.backgroundColor = ColorHepler.homeSectionColor
        sectionView.backgroundView = sectionColorView
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier, for: indexPath) as! RecordTableViewCell
        guard viewModel.recordDatas[indexPath.section].recordDatas.count > indexPath.row else { return UITableViewCell() }
        
        let cellData = viewModel.recordDatas[indexPath.section].recordDatas[indexPath.row]
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
