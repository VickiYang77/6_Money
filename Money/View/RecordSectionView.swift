//
//  RecordSectionView.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/14.
//

import UIKit

class RecordSectionView: UITableViewHeaderFooterView {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dateLabel.textColor = .white
        totalLabel.textColor = .white
        
        let view = UIView()
        view.backgroundColor = .topicBlue
        backgroundView = view
    }
    
    func setup(date: Date, total: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateLabel.text = dateFormatter.string(from: date)
        totalLabel.text = "$\(total)"
    }
}
