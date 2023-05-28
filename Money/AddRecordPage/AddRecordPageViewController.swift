//
//  AddRecordPageViewController.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/27.
//

import UIKit

class AddRecordPageViewController: UIViewController {
    @IBOutlet weak var memoTextField: UITextField!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var calculateStackView: UIStackView!
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    
    var viewModel = AddRecordPageViewModel()
    
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
    }
    
    @IBAction func clickCalculateBtn(_ sender: UIButton) {
        let btnTag = sender.tag
        print("vv_\(btnTag)")
        
        switch btnTag {
        case 0...9:
            viewModel.total += btnTag
        case 91...94:
            sender.backgroundColor = .topicRed
            viewModel.currentSymbolTag = btnTag
            
        case 999:
            print("vvv_ok:\(memoTextField.text)")
            navigationController?.popViewController(animated: true)
        default:
            return
        }
    }
    
}
