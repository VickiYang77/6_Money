//
//  EditRecordViewController.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/27.
//

import UIKit
import Combine

class EditRecordViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var calculateStackView: UIStackView!
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    
    let datePicker = UIDatePicker()
    let viewModel: EditRecordViewModel
    private var cancellable = Set<AnyCancellable>()
    
    init(viewModel: EditRecordViewModel) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: Self.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        
        titleTextField.delegate = self
        titleTextField.text = viewModel.titleText
        
        setupDatePicker()
        setupCollectionView()
        
        // 收合鍵盤
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(disableKeyboard(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    private func setupBinding() {
        viewModel.$priceTotal
            .receive(on: RunLoop.main)
            .map { String($0) }
            .assign(to: \.text, on: priceLabel)
            .store(in: &cancellable)
        
        viewModel.$type
            .receive(on: RunLoop.main)
            .map { UIImage(systemName: $0.fields.icon) }
            .assign(to: \.image, on: typeImageView)
            .store(in: &cancellable)
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
            viewModel.priceTotal += btnTag * 10
            
//        case 91...94:
//            sender.backgroundColor = .topicRed
//            viewModel.currentOperatorTag = btnTag
            
        // Save
        case 999:
            let title = titleTextField.text != "" ? titleTextField.text : "title"
            let date = "\(dateTextField.text!) 00:00:00"
            let record = ApiRecordFieldsModel(title: title ?? "", price: viewModel.priceTotal, date: date, typeID: viewModel.type.fields.typeID, isExpense: 1)
            
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
    
    func setupDatePicker() {
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.date = viewModel.date
        
        dateTextField.text = DateFormatter.stringyyyyMMdd(from: datePicker.date)
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = createDatePickerToolbar()
        dateTextField.tintColor = .clear
        dateTextField.delegate = self
    }
    
    func createDatePickerToolbar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(datePickerDoneBtn))
        let spaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceItem,doneBtn], animated: true)
        return toolBar
    }
    
    @objc func datePickerDoneBtn() {
        dateTextField.text = DateFormatter.stringyyyyMMdd(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func disableKeyboard(_ gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

// MARK: UICollectionViewDataSource
extension EditRecordViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  kAM.share.types.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TypeCollectionViewCell.identifier, for: indexPath) as! TypeCollectionViewCell
        
        guard kAM.share.types.count > indexPath.row else { return UICollectionViewCell() }
        
        let typeInfo =  kAM.share.types[indexPath.row].fields
        cell.setup(name: typeInfo.name, image: typeInfo.icon)
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension EditRecordViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.type =  kAM.share.types[indexPath.row]
    }
}

// MARK: UITextFieldDelegate
extension EditRecordViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
