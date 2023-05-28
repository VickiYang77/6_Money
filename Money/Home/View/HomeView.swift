//
//  HomeView.swift
//  Money
//
//  Created by Vicki Yang on 2023/5/28.
//

import UIKit

class HomeView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNibContent()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadNibContent() {
        let view = Bundle.main.loadNibNamed("HomeView", owner: self, options: nil)?.first as! UIView
        view.frame = self.frame
        addSubview(view)
    }
}
