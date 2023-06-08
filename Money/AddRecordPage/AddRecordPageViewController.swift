//
//  AddRecordPageViewController.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/27.
//

import UIKit

class AddRecordPageViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var calculateStackView: UIStackView!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    
    let viewModel: AddRecordPageViewModel
    
    init(viewModel: AddRecordPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchTypes()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.tintColor = .black
        
        calculateStackView.arrangedSubviews.forEach { subview in
            if let stackView = subview as? UIStackView {
                stackView.arrangedSubviews.compactMap({ $0 as? UIButton })
                    .forEach { btn in
                        btn.layer.cornerRadius = 30
                        btn.layer.masksToBounds = true
                        btn.layer.borderWidth = 2
                        btn.layer.borderColor = UIColor.black.cgColor
                    }
            }
        }
        
        titleTextField.text = viewModel.titleText
        priceLabel.text = "$ \(viewModel.priceTotal)"
        datePicker.date = viewModel.date
        
        setupCollectionView()
    }
    
    private func bindViewModel() {
        viewModel.reloadData = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
                if let type = self?.viewModel.types.first(where: { $0.fields.typeID == self?.viewModel.typeID}) {
                    self?.typeImageView.image = UIImage(systemName: type.fields.icon)
                }
            }
        }
    }
    
    func setupCollectionView() {
        collectionView.register(TypeCollectionViewCell.nib(), forCellWithReuseIdentifier: TypeCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let itemSpace: Double = 5
        let horizontalCount: Double = 4
        let verticalCount: Double = 3
        let width = floor((collectionView.bounds.size.width - itemSpace * (horizontalCount-1)) / horizontalCount)
        let height = floor((collectionView.bounds.size.height - itemSpace * verticalCount) / verticalCount)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: width, height: height)
        layout.estimatedItemSize = .zero
        layout.minimumInteritemSpacing = itemSpace
        layout.minimumLineSpacing = itemSpace
        collectionView.setCollectionViewLayout(layout, animated: false)
    }

    
    @IBAction func clickCalculateBtn(_ sender: UIButton) {
        let btnTag = sender.tag
        print("vv_\(btnTag)")
        
        switch btnTag {
        case 0...9:
            viewModel.priceTotal += btnTag * 100
            priceLabel.text = "$ \(viewModel.priceTotal)"
        case 91...94:
            sender.backgroundColor = .topicRed
            viewModel.currentOperatorTag = btnTag
            
        case 999:
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let recordDate = formatter.string(from: datePicker.date)
            
            let record = RecordFieldsModel(title: titleTextField.text ?? "", price: viewModel.priceTotal, date: recordDate, typeID: "recBoPXAUe0KzPiW9", isExpense: 1)
            
            if viewModel.recordID != "" {
                let records = updateRecordRequest(records: [
                    .init(id: viewModel.recordID, fields: record)
                ])
                
                APIService.share.updateRecords(records) { [weak self] in
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                let records = InsertRecordRequest(records: [
                    .init(fields: record)
                ])
                
                APIService.share.insertRecords(records) { [weak self] in
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        default:
            return
        }
    }
}

extension AddRecordPageViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionViewCell.identifier, for: indexPath) as! TypeCollectionViewCell
        
        guard viewModel.types.count > indexPath.row else { return UICollectionViewCell() }
        
        let data = viewModel.types[indexPath.row].fields
        cell.setup(name: data.name, image: data.icon)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellData = viewModel.types[indexPath.row].fields
        typeImageView.image = UIImage(systemName: cellData.icon)
        viewModel.typeID = cellData.typeID
    }
}
