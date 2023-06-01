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
        let vc = AddRecordPageViewController(viewModel: AddRecordPageViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dateSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = viewModel.dateSection[section]
        return viewModel.recordsDic[date]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecordSectionView.identifier) as! RecordSectionView
        
        guard viewModel.dateSection.count > section else { return UITableViewHeaderFooterView() }
        
        let date = viewModel.dateSection[section]
        let total = viewModel.recordsDic[date]?.reduce(0, { $0 + $1.fields.price}) ?? 0
        sectionView.setupUI(date: date, total: "\(total)")
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier, for: indexPath) as! RecordTableViewCell
        
        let date = viewModel.dateSection[indexPath.section]
        guard let cellDatas = viewModel.recordsDic[date], cellDatas.count > indexPath.row else { return UITableViewCell() }
        
        let cellData = cellDatas[indexPath.row].fields
        cell.setupUI(typeID: cellData.typeID, title: cellData.title, price: "\(cellData.price)")
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let date = self.viewModel.dateSection[indexPath.section]
        if let cellData = self.viewModel.recordsDic[date]?[indexPath.row] {
            let vm = AddRecordPageViewModel(id: cellData.id, titleText: cellData.fields.title, priceTotal: cellData.fields.price, dateString: cellData.fields.date, typeID: cellData.fields.typeID, isExpense: cellData.fields.isExpense)
            let vc = AddRecordPageViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { [weak self] (action, sourceView, completionHandler) in
            guard let self = self else { return }
            
            let date = self.viewModel.dateSection[indexPath.section]
            if let cellData = self.viewModel.recordsDic[date]?[indexPath.row] {
                RecordAPIService.share.deleteRecords([cellData.id]) {
                    DispatchQueue.main.async {
                        self.viewModel.recordsDic[date]?.remove(at: indexPath.row)
                        if self.viewModel.recordsDic[date]?.count == 0 {
                            self.viewModel.dateSection.remove(at: indexPath.section)
                            UIView.performWithoutAnimation {
                                self.tableView.beginUpdates()
                                self.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .fade)
                                self.tableView.endUpdates()
                            }
                        } else {
                            UIView.performWithoutAnimation {
                                self.tableView.beginUpdates()
                                self.tableView.deleteRows(at: [indexPath], with: .fade)
                                self.tableView.endUpdates()
                            }
                        }
                        
                        completionHandler(true)
                    }
                }
            }
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        let trailingSwipConfiguration = UISwipeActionsConfiguration(actions: [deleteAction])
        return trailingSwipConfiguration
    }
}
