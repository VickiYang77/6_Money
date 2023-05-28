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
    
    func setupUI(date: String, total: String) {
        dateLabel.text = date
        totalLabel.text = "$\(total)"
    }
}
