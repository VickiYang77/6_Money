//
//  RecordTableViewCell.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/14.
//

import UIKit

enum recordType {
    case none
    case dailyNecessities
    case breakfast
    case lunch
    case dinner
    case dessert
    case drinks
    case shopping
    case transportation
    case gift
    
    var icon: String {
        switch self {
        case .none:                 return "dollarsign.circle"
        case .dailyNecessities:     return "cart"
        case .breakfast:            return "fork.knife"
        case .lunch:                return "fork.knife"
        case .dinner:               return "fork.knife"
        case .dessert:              return "fork.knife"
        case .drinks:               return "cup.and.saucer"
        case .shopping:             return "bag"
        case .transportation:       return "tram"
        case .gift:                 return "gift"
        }
    }
}

class RecordTableViewCell: UITableViewCell {
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func setupUI(typeID: String? = "", title: String, price: String) {
        typeImageView.image = (typeID == nil || typeID == "") ? UIImage(systemName: recordType.none.icon) : UIImage(systemName: recordType.gift.icon)
        recordLabel.text = title
        priceLabel.text = "$\(price)"
        
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1.0
    }
}
