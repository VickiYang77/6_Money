//
//  HomeViewController.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/13.
//

import UIKit
import Combine

// Diffable Data Source
typealias HomeDataSource = UITableViewDiffableDataSource<HomeSection, RecordModel>
typealias HomeSnapshot = NSDiffableDataSourceSnapshot<HomeSection, RecordModel>

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
    
    private lazy var dataSource = makeDataSource()
    
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
        tableView.dataSource = dataSource
        tableView.register(RecordSectionView.nib(), forHeaderFooterViewReuseIdentifier: RecordSectionView.identifier)
        tableView.register(RecordTableViewCell.nib(), forCellReuseIdentifier: RecordTableViewCell.identifier)
        
        tableView.tableHeaderView = homeHeaderView
    }
    
    private func setupBinding() {
        // 更新 tableView
        viewModel.$records
            .combineLatest(viewModel.$dateSection)
            .receive(on: RunLoop.main)
            .sink { [weak self] (records, dataSection) in
                guard let self = self else { return }
                var snapshot = HomeSnapshot()
                for date in dataSection {
                    let items = self.viewModel.getRecordsWith(date)
                    snapshot.appendSections([HomeSection(date: date)])
                    snapshot.appendItems(items, toSection: HomeSection(date: date))
                }
                
                self.dataSource.defaultRowAnimation = .fade
                self.dataSource.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellable)
    }
    
    @IBAction func clickAddRecordBtn(_ sender: Any) {
        let vc = EditRecordViewController(viewModel: EditRecordViewModel())
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: - UITableView DiffableData Source
struct HomeSection: Hashable {
    let date: Date
}

@available(iOS 13.0, *)
fileprivate extension HomeViewController {
    func makeDataSource() -> HomeDataSource {
        return HomeDataSource(tableView: tableView) { [weak self]  tableView, indexPath, item in
            guard let self = self else { return UITableViewCell() }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: RecordTableViewCell.identifier, for: indexPath) as! RecordTableViewCell
            let cellDatas = self.viewModel.getSectionRecords(indexPath.section)
            guard cellDatas.count > indexPath.row else { return UITableViewCell() }
            
            let cellInfo = cellDatas[indexPath.row].fields
            cell.setupUI(typeID: cellInfo.typeID, title: cellInfo.title, price: "\(cellInfo.price)")
            return cell
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: RecordSectionView.identifier) as! RecordSectionView
        
        guard viewModel.dateSection.count > section else { return UITableViewHeaderFooterView() }
        
        let date = viewModel.dateSection[section]
        let total = viewModel.getRecordsWith(date).reduce(0, { $0 + $1.fields.price })
        sectionView.setup(date: date, total: "\(total)")
        return sectionView
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
        let cellDatas = viewModel.getSectionRecords(indexPath.section)
        if cellDatas.count > indexPath.row {
            tableView.deselectRow(at: indexPath, animated: true)
            
            let cellInfo = cellDatas[indexPath.row]
            let vm = EditRecordViewModel(cellInfo, isEdit: true)
            let vc = EditRecordViewController(viewModel: vm)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let copyAction = UIContextualAction(style: .normal, title: "Copy") { [weak self] (action, sourceView, completionHandler) in
            guard let self = self else { return }
            
            let cellDatas = self.viewModel.getSectionRecords(indexPath.section)
            if cellDatas.count > indexPath.row {
                let cellInfo = cellDatas[indexPath.row]
                let vm = EditRecordViewModel(RecordModel(id: "", createdTime: "", fields: cellInfo.fields))
                let vc = EditRecordViewController(viewModel: vm)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            completionHandler(true)
        }
        
        copyAction.image = UIImage(systemName: "doc.on.doc")
        copyAction.backgroundColor = .topicYellow
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (action, sourceView, completionHandler) in
            guard let self = self else { return }
            
            let cellDatas = self.viewModel.getSectionRecords(indexPath.section)
            if cellDatas.count > indexPath.row {
                let cellInfo = cellDatas[indexPath.row]
                APIService.share.deleteRecords([cellInfo.id]) {
                    DispatchQueue.main.async {
                        self.viewModel.records.removeAll(where: { $0.id == cellInfo.id })
                        if self.viewModel.getSectionRecords(indexPath.section).count == 0 {
                            self.viewModel.dateSection.remove(at: indexPath.section)
                        }
                        
                        completionHandler(true)
                    }
                }
            }
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [copyAction, deleteAction])
    }
}
