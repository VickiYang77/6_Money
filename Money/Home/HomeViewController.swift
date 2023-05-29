//
//  HomeViewController.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/13.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var addRecordBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var homeView: HomeView = {
        var view = HomeView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4))
        return view
    }()
    
    var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchRecords()
    }
    
    private func setupUI() {
        navigationItem.title = "Money Note"
        navigationController?.navigationBar.addBottomSeparator()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecordSectionView.nib(), forHeaderFooterViewReuseIdentifier: RecordSectionView.identifier)
        tableView.register(RecordTableViewCell.nib(), forCellReuseIdentifier: RecordTableViewCell.identifier)
        
        tableView.tableHeaderView = self.homeView
    }
    
    private func bindViewModel() {
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @IBAction func clickAddRecordBtn(_ sender: Any) {
        let vc = AddRecordPageViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dateSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = viewModel.dateSection[section]
        return viewModel.records[date]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecordSectionView.identifier) as! RecordSectionView
        
        guard viewModel.dateSection.count > section else { return UITableViewHeaderFooterView() }
        
        let date = viewModel.dateSection[section]
        let total = viewModel.records[date]?.reduce(0, { $0 + $1.price}) ?? 0
        sectionView.setupUI(date: date, total: "\(total)")
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier, for: indexPath) as! RecordTableViewCell
        
        let date = viewModel.dateSection[indexPath.section]
        guard let cellDatas = viewModel.records[date], cellDatas.count > indexPath.row else { return UITableViewCell() }
        
        let cellData = cellDatas[indexPath.row]
        cell.setupUI(typeId: cellData.typeId, title: cellData.title, price: "\(cellData.price)")
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
