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
    }
    
    func setupUI(date: String, total: String) {
        self.dateLabel.text = date
        self.totalLabel.text = "$\(total)"
    }
}
