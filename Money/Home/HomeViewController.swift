//
//  HomeViewController.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/13.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    @IBOutlet weak var addRecordBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    lazy var homeHeaderView: HomeHeaderView = {
        let view = HomeHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.4), viewModel: viewModel)
        return view
    }()
    
    // MARK: Parameter
    var viewModel = HomeViewModel()
    private var cancellable = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchRecords.send()
    }
    
    private func setupUI() {
        navigationItem.title = "Money Note"
        navigationController?.navigationBar.addBottomSeparator()
        
        let backBtn = UIBarButtonItem()
        backBtn.title = ""
        navigationItem.backBarButtonItem = backBtn
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(RecordSectionView.nib(), forHeaderFooterViewReuseIdentifier: RecordSectionView.identifier)
        tableView.register(RecordTableViewCell.nib(), forCellReuseIdentifier: RecordTableViewCell.identifier)
        
        tableView.tableHeaderView = homeHeaderView
    }
    
    private func setupBinding() {
        // 更新 tableView
        viewModel.$records
            .combineLatest(viewModel.$dateSection)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellable)
    }
    
    @IBAction func clickAddRecordBtn(_ sender: Any) {
        let vc = EditRecordViewController(viewModel: EditRecordViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.dateSection.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = viewModel.dateSection[section]
        return viewModel.records.filter{ $0.fields.date == date }.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecordSectionView.identifier) as! RecordSectionView
        
        guard viewModel.dateSection.count > section else { return UITableViewHeaderFooterView() }
        
        let date = viewModel.dateSection[section]
        let total = viewModel.records.filter{ $0.fields.date == date }.reduce(0, { $0 + $1.fields.price})
        sectionView.setup(date: date, total: "\(total)")
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier, for: indexPath) as! RecordTableViewCell
        
        let date = viewModel.dateSection[indexPath.section]
        let cellDatas = viewModel.records.filter({ $0.fields.date == date })
        guard cellDatas.count > indexPath.row else { return UITableViewCell() }
        
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
        let date = viewModel.dateSection[indexPath.section]
        let cellDatas = viewModel.records.filter({ $0.fields.date == date })
        if cellDatas.count > indexPath.row {
            let cellData = cellDatas[indexPath.row]
            let vm = EditRecordViewModel(cellData, isEdit: true)
            let vc = EditRecordViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { [weak self] (action, sourceView, completionHandler) in
            guard let self = self else { return }
            
            let date = self.viewModel.dateSection[indexPath.section]
            let cellDatas = self.viewModel.records.filter({ $0.fields.date == date })
            if cellDatas.count > indexPath.row {
                let cellData = cellDatas[indexPath.row]
                APIService.share.deleteRecords([cellData.id]) {
                    DispatchQueue.main.async {
                        self.viewModel.records.removeAll(where: { $0.id == cellData.id })
                        if self.viewModel.records.filter({ $0.fields.date == date }).count == 0 {
                            self.viewModel.dateSection.remove(at: indexPath.section)
                        }
                        
                        completionHandler(true)
                    }
                }
            }
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        let actions = UISwipeActionsConfiguration(actions: [deleteAction])
        return actions
    }
}
