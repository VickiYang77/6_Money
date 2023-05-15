//
//  RecordTableViewCell.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/14.
//

import UIKit

enum costType {
    case none
    case dailyNecessities
    case breakfast
    case lunch
    case dinner
    case dessert
    case drinks
    case shopping
    case transportation
}

class RecordTableViewCell: UITableViewCell {
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func setupUI(type: costType = .none, title: String, price: String) {
        self.recordLabel.text = title
        self.priceLabel.text = "$\(price)"
    }
}
