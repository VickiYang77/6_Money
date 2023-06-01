//
//  AddRecordPageViewController.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/27.
//

import UIKit

class AddRecordPageViewController: UIViewController {
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
    }
    
    private func setupUI() {
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
            
            if viewModel.id != "" {
                let records = updateRecordRequest(records: [
                    .init(id: viewModel.id, fields: record)
                ])
                
                RecordAPIService.share.updateRecords(records) { [weak self] in
                    DispatchQueue.main.async {
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            } else {
                let records = InsertRecordRequest(records: [
                    .init(fields: record)
                ])
                
                RecordAPIService.share.insertRecords(records) { [weak self] in
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
