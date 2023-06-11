//
//  RecordTableViewCell.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/14.
//

import UIKit

class RecordTableViewCell: UITableViewCell {
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var recordLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    func setupUI(typeID: String? = "", title: String, price: String, image: String) {
        typeImageView.image = (typeID != nil && typeID == "") ? UIImage(systemName: image) : RecordTypeImage.none.getImage()
        recordLabel.text = title
        priceLabel.text = "$\(price)"
        
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1.0
    }
}
